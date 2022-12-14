//
//  HomeViewController.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salir", style: .done, target: self, action: #selector(signOutTap))
        configureViews()
        tableView?.register( UINib(nibName: HomeTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.cellIdentifier )
        viewModel.onError = onError(message:)
        viewModel.onSuccessLoad = onSuccesLoad
        viewModel.loadHeroes()
    }
    
    @objc func signOutTap(){
        viewModel.signOut()
        DispatchQueue.main.async {
            let nextView = LoginViewController();
            self.navigationController?.setViewControllers([nextView], animated: true)
        }
    }
    
    private func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

}

extension HomeViewController {
    func onSuccesLoad() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func onError(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "", message: message)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellIdentifier, for: indexPath) as? HomeTableViewCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "no content"
            return cell
        }
        cell.updateViews(data: viewModel.content[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = viewModel.content[indexPath.row]
        let nextVC = MapViewController()
        nextVC.set(model: hero)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: call Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
        UIView.animate(withDuration: 0.4, delay: 0.04 * Double(indexPath.row)) {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        }
    }
}

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchHero(by: searchText)
    }
    
}
