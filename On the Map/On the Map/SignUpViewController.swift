//
//  SignUpViewController.swift
//  On the Map
//
//  Created by Maike Schmidt on 08/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MArk: Outlet
    @IBOutlet weak var webView: UIWebView!
    
    //TODO: Finish web view
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(URLRequest(url: URL(string: "https://www.udacity.com/account/auth#!/signup")!))
    }

    @IBAction func backButtonPressed(_ sender: Any) {
    
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
    

}
