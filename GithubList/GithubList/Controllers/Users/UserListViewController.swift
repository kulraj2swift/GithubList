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
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var viewModel: UserListViewModel!
    
    let footerHeight: CGFloat = 44

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        callApi()
        usersTableView.register(UINib(nibName: UserTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        //usersTableView.register(UIView.self, forHeaderFooterViewReuseIdentifier: "FooterReuse")
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        callApi()
    }

    func callApi() {
        activityIndicator.startAnimating()
        viewModel.searchForUsers(text: searchTextField.text)
    }

    @IBAction func sortTapped(_ sender: Any) {
        let sortViewController = SortOptionsViewController(nibName: "SortOptionsViewController", bundle: nil)
        sortViewController.selectedSortOrder = viewModel.selectedSortOrder
        sortViewController.selectedSortOption = viewModel.selectedSortOption
        sortViewController.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
        sortViewController.onApply = { [weak self] sortOption, sortOrder in
            self?.viewModel.selectedSortOrder = sortOrder
            self?.viewModel.selectedSortOption = sortOption
            self?.viewModel.applySorting()
            self?.reloadUsers()
            self?.dismiss(animated: true)
        }
        present(sortViewController, animated: true)
    }
    
    func reloadUsers() {
        if viewModel.sortedUsers.isEmpty {
            usersTableView.isHidden = true
            noResultsLabel.isHidden = false
        } else {
            usersTableView.isHidden = false
            noResultsLabel.isHidden = true
            usersTableView.reloadData()
        }
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier) as! UserTableViewCell
        userCell.user = viewModel.sortedUsers[indexPath.row]
        if indexPath.row == viewModel.sortedUsers.count - 1,
           viewModel.incompleteResults {
            viewModel.fetchNextBatch()
        }
        return userCell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.incompleteResults {
            let loader = UIActivityIndicatorView(style: .medium)
            loader.color = .black
            loader.startAnimating()
            view.addSubview(loader)
            return loader
        }
        return nil
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.sortedUsers[indexPath.row]
        let detailsViewController = UserDetailViewController(nibName: "UserDetailViewController", bundle: nil)
        let detailsViewModel = UserDetailsViewModel()
        detailsViewModel.user = user
        detailsViewController.viewModel = detailsViewModel
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension UserListViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        callApi()
        return true
    }
}

extension UserListViewController: UserListViewModelDelegate {
    func usersFetched(isSearchTextChanged: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.reloadUsers()
            if isSearchTextChanged,
               (self?.viewModel.users.count ?? 0) > 0 {
                self?.usersTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    func failedtoFetchUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            if self?.viewModel.users.count == 0 {
                self?.showAlert()
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Something went wrong", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
