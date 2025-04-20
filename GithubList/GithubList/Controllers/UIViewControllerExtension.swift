//
//  UIViewControllerExtension.swift
//  GithubList
//
//  Created by kulraj singh on 20/04/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setBackbutton() {
        let chevronImage = UIImage.init(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevronImage, style: .done, target: self, action: #selector(popToPreviousScreen))
        navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    @objc func popToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }
}
