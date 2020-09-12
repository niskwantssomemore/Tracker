//
//  AuthenticationViewController.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 10.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        if (login == "" || password == "") {
            showErrorLoginPasswordFillAlertController()
        }
        else {
            if (RealmService.instance.signInUser(login: login!, password: password!)) {
                performSegue(withIdentifier: "signInSignUpSegue", sender: nil)
            }
            else {
                showErrorNoSuchUserAlertController()
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        if (login == "" || password == "") {
            showErrorLoginPasswordFillAlertController()
        }
        else {
            if RealmService.instance.registerUser(login: login!, password: password!) {
                performSegue(withIdentifier: "signInSignUpSegue", sender: nil)
            }
        }
    }
}

extension AuthenticationViewController {
    func showErrorLoginPasswordFillAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Please fill in login and password fields to continue", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorNoSuchUserAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Such user doesn't exist", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
