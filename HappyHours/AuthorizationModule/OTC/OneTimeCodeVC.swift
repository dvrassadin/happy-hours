//
//  OneTimeCodeVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - OneTimeCodeVC class

final class OneTimeCodeVC: UIViewController {
    
    // MARK: Properties
    
    private lazy var otcView = OneTimeCodeView(numberOfDigits: 4)

    // MARK: Lifecycle
    
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
            self?.navigationController?.pushViewController(NewPasswordVC(), animated: true)
        }
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    OneTimeCodeVC()
}
