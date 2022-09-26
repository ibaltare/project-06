//
//  LoginViewController.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onSuccess = onLoginSucces
        viewModel.onError = onLoginError(message:)
    }
    
    @IBAction func onLoginTap(_ sender: Any) {
        if let user = userField.text, let pass = passwordField.text {
            if !user.isEmpty, !pass.isEmpty{
                loginButton.isEnabled = false
                activityIndicator.startAnimating()
                viewModel.login(with: user, password: pass)
            }
        }
    }
}

extension LoginViewController {
    func onLoginSucces() {
        DispatchQueue.main.async {
            self.loginButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            let nextView = HomeViewController();
            self.navigationController?.setViewControllers([nextView], animated: true)
        }
    }
    
    func onLoginError(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "", message: message)
            self.loginButton.isEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }
}
