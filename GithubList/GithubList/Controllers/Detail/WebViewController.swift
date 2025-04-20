//
//  WebViewController.swift
//  GithubList
//
//  Created by kulraj singh on 20/04/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webKitView: WKWebView!
    var repositoryLink: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = title
        if let urlText = repositoryLink,
           let url = URL(string: urlText) {
            let urlRequest = URLRequest(url: url)
            webKitView.load(urlRequest)
        } else {
            let alert = UIAlertAction(title: "URL is not correct", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            })
        }
    }

}

extension WebViewController: WKNavigationDelegate {
    
}
