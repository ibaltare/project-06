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
    @IBOutlet weak var imgGoku: UIImageView!
    @IBOutlet weak var backContainer: UIView!
    
    let viewModel = LoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        backContainer.center.y += view.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onSuccess = onLoginSucces
        viewModel.onError = onLoginError(message:)
        prepareView()
        showAnimation()
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
    
    private func prepareView() {
        backContainer.layer.cornerRadius = 16.0
        backContainer.layer.shadowColor = UIColor.gray.cgColor
        backContainer.layer.shadowOffset = .zero
        backContainer.layer.shadowOpacity = 0.7
        backContainer.layer.shadowRadius = 16.0
        
    }
    
    private func showAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0) {
            self.backContainer.center.y -= self.view.bounds.height
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
