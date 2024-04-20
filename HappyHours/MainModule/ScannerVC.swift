//
//  ScannerVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit
import AVFoundation

// MARK: - ScannerVC class

final class ScannerVC: UIViewController {

    // MARK: Properties

    private let session = AVCaptureSession()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScanner()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.session.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
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
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        else { return }
        
        // TODO: Make logic
        let alert = UIAlertController(
            title: "QR Code",
            message: object.stringValue,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true)
        session.stopRunning()
    }
    
}
