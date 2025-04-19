//
//  UserListViewController.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: UserListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        callApi()
        usersTableView.register(UINib(nibName: UserTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        callApi()
    }

    func callApi() {
        activityIndicator.startAnimating()
        viewModel.searchForUsers(text: searchTextField.text)
    }

}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier) as! UserTableViewCell
        userCell.user = viewModel.users[indexPath.row]
        return userCell
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UserListViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserListViewController: UserListViewModelDelegate {
    func usersFetched() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.usersTableView.reloadData()
        }
    }
    
    func failedtoFetchUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.showAlert()
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Something went wrong", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
