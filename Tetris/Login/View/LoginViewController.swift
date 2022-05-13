//
//  LoginViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 08.05.2022.
//

import UIKit

protocol viewLoginProtocol: AnyObject {
    func showInvalid(_ str:String)
    func showWaiting()
}


class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!

    private var presenter: LoginPresenterProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        loginTextField.delegate = self
        label.isHidden = true
        var pre = LoginPresenter()
        pre.view = self
        presenter = pre

        // Do any additional setup after loading the view.
    }


    @IBAction func registration(_ sender: Any) {
        self.navigationController?.pushViewController(RegestrationViewController(), animated: true)
    }

    @IBAction func touchButton(_ sender: Any) {
        if let loginTextField = loginTextField.text, let passwordTextField = passwordTextField.text {
            if loginTextField != "", passwordTextField != ""{
                presenter?.login(login: loginTextField, password: passwordTextField)
            }
        }
    }
    @IBAction func editText(_ sender: Any) {
        label.isHidden = true
    }
}

extension LoginViewController: viewLoginProtocol {
    func showWaiting() {
        let vc = WaitingRoomViewController(nibName: "WaitingRoomViewController", bundle: nil)
        vc.username = loginTextField.text
       self.navigationController?.pushViewController(vc, animated: true)
    }

    func showInvalid(_ str:String) {
        label.text = str
        label.isHidden = false
        passwordTextField.text = ""
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            touchButton(textField)
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

