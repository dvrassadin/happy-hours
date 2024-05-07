//
//  OneTimeCodeVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - OneTimeCodeVC class

final class OneTimeCodeVC: UIViewController, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var otcView = OneTimeCodeView(numberOfDigits: 4)
    private let model: AuthorizationModelProtocol

    // MARK: Lifecycle
    
    init(model: AuthorizationModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = otcView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otcView.codeTextField.becomeFirstResponder()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        otcView.oneTimeCodeFilled = { [weak self] code in
            guard let self, let code = self.otcView.codeTextField.text else { return }
            Task {
                do {
                    try await self.model.sendOTC(code)
                    self.navigationController?.pushViewController(
                        NewPasswordVC(model: self.model),
                        animated: true
                    )
                } catch {
                    self.showAlert(.incorrectOTC)
                }
            }
        }
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    OneTimeCodeVC(model: AuthorizationModel(networkService: NetworkService()))
}
