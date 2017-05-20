//
//  LoginViewController.swift
//  On the Map
//
//  Created by Maike Schmidt on 02/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    //MARK: Properties
    var session: URLSession!
    var appDelegate: AppDelegate!

    //MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: check if email and password fields filled out 
        
        session = URLSession.shared
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //set UI enabled
    //TODO: Use it
    func setUIEnabled(_ enabled: Bool) {
            loginButton.isEnabled = enabled
        
        //adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    //MARK: LoginButton pressed
    @IBAction func loginButtonPressed(_ sender: Any) {

        if emailTextField.text == "" || passwordTextField.text == "" {
            print("Email or password text field empty")
        } else {
            Constants.LoginData.username = emailTextField.text!
            Constants.LoginData.password = passwordTextField.text!
            
            UdacityClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
                performUpdatesOnMain {
                    if success {
                        self.finishLogin()
                    } else {
                        performUpdatesOnMain {
                        //MARK: ToDo: alert view
                            print(errorString as Any)
                        }
                    }
                }
            }
        }
    }

//    func completionHandlerForSuccessfulLogin(success: Bool, result: AnyObject?, error: NSError?) -> Void {
//    
//        if success {
//            let controller = storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//            present(controller, animated: true, completion: nil)
//        } else {
//            //TODO: enumerate erros (guard statements)
//            print("Login was not successful")
//        }
//    }
    
    //TODO: Fix this!
    //check if email address conforms to standard 
    func isValidEmail(emailString: String) -> Bool {
    
        let includedInEmail = "[A-Z0-9a-z.-%+-] +@ [A-Za-z0-9.-] + \\.[A-Za-z] {2,}"
        let validateEmail = NSPredicate(format: "SELF MATCHES %@", includedInEmail)
        return validateEmail.evaluate(with: emailString)
    }
    
    
    //Complete login
    func finishLogin() {
        performUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
//            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
//            self.present(controller, animated: true, completion: nil)
        }
    }
    

    }


