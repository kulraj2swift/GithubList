//
//  UserTableViewCell.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import UIKit
import AlamofireImage

class UserTableViewCell: UITableViewCell {
    
    static let nibName = "UserTableViewCell"
    static let reuseIdentifier = "UserCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    var user: User? {
        didSet {
            loginLabel.text = user?.login
            if let avatar = user?.avatarUrl,
               let avatarUrl = URL(string: avatar) {
                let id = String(user?.id ?? 0)
                avatarImageView.af.setImage(withURL: avatarUrl, cacheKey: id)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
    
}
