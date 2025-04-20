//
//  RepositoryTableViewCell.swift
//  GithubList
//
//  Created by kulraj singh on 20/04/25.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    static let nibName = "RepositoryTableViewCell"
    static let reuseIdentifier = "RepositoryCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var developmentLanguageLabel: UILabel!
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    var repository: Repository? {
        didSet {
            guard let repository = repository else { return }
            if let repoName = repository.name {
                repositoryNameLabel.text = "Repository Name: " + repoName
            }
            numberOfStarsLabel.text = "1"
            if let description = repository.description,
               !description.isEmpty {
                descriptionLabel.isHidden = false
                descriptionLabel.text = description
            } else {
                descriptionLabel.isHidden = true
            }
            if repository.language?.isEmpty == true {
                developmentLanguageLabel.isHidden = true
            } else {
                developmentLanguageLabel.isHidden = false
                developmentLanguageLabel.text = "Development language: \(repository.language ?? "")"
            }
            if let stargazersCount = repository.stargazersCount {
                numberOfStarsLabel.text = "Number of stars: \(stargazersCount)"
                numberOfStarsLabel.isHidden = false
            } else {
                numberOfStarsLabel.isHidden = true
            }
        }
    }
    
}
