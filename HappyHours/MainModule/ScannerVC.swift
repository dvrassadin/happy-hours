//
//  ScannerVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit
import AVFoundation

// MARK: - ScannerVC class

final class ScannerVC: UIViewController, AlertPresenter {

    // MARK: Properties

    private let session = AVCaptureSession()
    private let networkService: NetworkServiceProtocol
    private let userService: UserServiceProtocol
    private let queue = DispatchQueue(label: "ScannerQueue")
    
    // MARK: UI Components
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .main
        return activityIndicator
    }()
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol, userService: UserServiceProtocol) {
        self.networkService = networkService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScanner()
        setUpUI()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        queue.async {
            self.session.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: Set up scanner
    
    func setUpScanner() {
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            showCouldNotTurnOnScannerAlert()
            return
        }
        
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        
        let video = AVCaptureVideoPreviewLayer(session: session)
        video.videoGravity = .resizeAspectFill
        video.frame = view.layer.bounds
        if let tabBarHeight = tabBarController?.tabBar.bounds.height {
            video.frame.size.height -= tabBarHeight
        }
        
        view.layer.addSublayer(video)
    }
    
    // MARK: Alert
    
    private func showCouldNotTurnOnScannerAlert() {
        let alert = UIAlertController(
            title: String(localized: "Camera Error"),
            message: String(localized: "Could not open code scanner."),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = object.stringValue,
              let id = Int(stringValue) else {
            session.stopRunning()
            showAlert(.invalidBarcode) { _ in
                self.queue.async {
                    self.session.startRunning()
                }
            }
            return
        }
        
        session.stopRunning()
        activityIndicator.startAnimating()
        Task {
            do {
                let restaurant = try await networkService.getRestaurant(id: id, allowRetry: true)
                let menuModel = MenuModel(
                    restaurant: restaurant,
                    logoImage: nil,
                    networkService: networkService
                )
                let menuVC = MenuVC(
                    model: menuModel,
                    userService: userService,
                    areOrdersEnable: true
                )
                navigationController?.pushViewController(menuVC, animated: true)
                activityIndicator.stopAnimating()
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                self.activityIndicator.stopAnimating()
                showAlert(.barcodeServerError) { _ in
                    self.queue.async {
                        self.session.startRunning()
                    }
                }
            }
        }
    }
    
}
