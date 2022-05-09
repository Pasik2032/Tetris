//
//  ViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 08.05.2022.
//

import UIKit

class ViewController: UIViewController {


    private let buttonSingel: UIButton = {
        let control = UIButton()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.setTitle("Одиночная игра", for: .normal)
        control.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        return control
    }()

    private let buttonMulty: UIButton = {
        let control = UIButton()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.setTitle("Мультиплеер", for: .normal)
        control.addTarget(self, action: #selector(touchButtonMulty), for: .touchUpInside)
        return control
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configUI()
        // Do any additional setup after loading the view.
    }

    private func configUI(){
        view.addSubview(buttonSingel)
        buttonSingel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonSingel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true

        view.addSubview(buttonMulty)
        buttonMulty.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonMulty.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true

    }

    @objc func touchButton() {
         self.navigationController?.pushViewController(ARViewController(), animated: true)
     }

    @objc func touchButtonMulty() {
         let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
     }



}

