//
//  UserDetailViewController.swift
//  GithubList
//
//  Created by kulraj singh on 20/04/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var viewModel: UserDetailsViewModel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.onRepositoryFetch = { [weak self] in
            DispatchQueue.main.async {
                self?.repositoriesTableView.reloadData()
            }
        }
        navigationItem.title = viewModel.user?.login
        setImage()
        callDetailApi()
        nameLabel.text = ""
        followersLabel.text = ""
        repositoriesTableView.register(UINib(nibName: RepositoryTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
    }
    
    func setImage() {
        let userId = String(viewModel.user?.id ?? 0)
        if let url = URL(string: viewModel.user?.avatarUrl ?? "") {
            avatarImageView.af.setImage(withURL: url, cacheKey: userId)
        }
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
    }
    
    func callDetailApi() {
        loadingIndicator.startAnimating()
        viewModel.getUserDetails()
    }

}

extension UserDetailViewController: UserDetailsViewModelDelegate {
    func userDetailsFetched() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
            self?.nameLabel.text = self?.viewModel.user?.name
            self?.followersLabel.text = "Number of followers: \(self?.viewModel.user?.followerCount ?? 0)"
        }
    }
    
    func failedToFetchDetails() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
            self?.showSomethingwentWrongAlert()
        }
    }
    
    func showSomethingwentWrongAlert() {
        let alertController = UIAlertController(title: "Something went wrong", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension UserDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.repositories.count == 0 {
            return "No repository found which is not a fork"
        } else {
            return "Repositories"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repository = viewModel.repositories[indexPath.row]
        let repoCell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reuseIdentifier) as! RepositoryTableViewCell
        repoCell.repository = repository
        return repoCell
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
