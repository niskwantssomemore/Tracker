//
//  AuthenticationViewController.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 10.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthenticationViewController: UIViewController {

    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsAvailability()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        if (RealmService.instance.signInUser(login: login!, password: password!)) {
            performSegue(withIdentifier: "signInSignUpSegue", sender: nil)
        }
        else {
            showErrorNoSuchUserAlertController()
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        if RealmService.instance.registerUser(login: login!, password: password!) {
            performSegue(withIdentifier: "signInSignUpSegue", sender: nil)
        }
    }
}

extension AuthenticationViewController {
    
    func showErrorNoSuchUserAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Such user doesn't exist", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setButtonsAvailability() {
        Observable
            .combineLatest(
                loginTextField.rx.text,
                passwordTextField.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            .bind(to: signInButton.rx.isEnabled, signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
