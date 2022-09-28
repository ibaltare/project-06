//
//  HomeViewController.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import UIKit

final class HomeViewController: UIViewController {

    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salir", style: .done, target: self, action: #selector(signOutTap))
        viewModel.onError = onError(message:)
        viewModel.onSuccess = onSucces
        viewModel.loadHeroes()
    }
    
    @objc func signOutTap(){
        viewModel.signOut()
        DispatchQueue.main.async {
            let nextView = LoginViewController();
            self.navigationController?.setViewControllers([nextView], animated: true)
        }
    }

}

extension HomeViewController {
    func onSucces() {
    }
    
    func onError(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "", message: message)
        }
    }
}
