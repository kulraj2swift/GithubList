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
        setBackbutton()
        navigationItem.title = title
        if let urlText = repositoryLink,
           let url = URL(string: urlText) {
            let urlRequest = URLRequest(url: url)
            webKitView.load(urlRequest)
        } else {
            let alert = UIAlertController(title: "URL is not correct", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            })
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }

}
