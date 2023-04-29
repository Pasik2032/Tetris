//
//  LoginViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 08.05.2022.
//

import UIKit

protocol LoginViewInputProtocol: AnyObject {
  func showInvalid(_ str: String)
  func close()
}

final class LoginViewController: UIViewController {

  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!

  private var presenter: LoginPresenterProtocol?

  init(presenter: LoginPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    passwordTextField.delegate = self
    loginTextField.delegate = self
    label.isHidden = true
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

extension LoginViewController: LoginViewInputProtocol {
  func close() {
    dismiss(animated: true)
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

