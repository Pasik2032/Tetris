//
//  RegestrationViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2022.
//

import UIKit

class RegestrationViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var alert: UILabel!
    override func viewDidLoad() {
        alert.isHidden = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: Any) {
        if let login = loginTextField.text, let password = passwordTextField.text,
           login != "", password != "" {
            NetworkAPI.getNetworkOnline().postUser(login: login, password: password) { input in
                DispatchQueue.main.async {
                if input == "Пользователь успешно создан"{
                    let alert = UIAlertController(title: "Готова", message: "Вы зарегестрированны", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            self.navigationController?.popViewController(animated: true)
                        case .cancel, .destructive:
                            print("cancek")
                        @unknown default:
                            print("@unknown")
                        }
                    }))
                    self.present(alert, animated: true)


                } else {
                    self.alert.isHidden = false
                    self.alert.text = input
                }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
