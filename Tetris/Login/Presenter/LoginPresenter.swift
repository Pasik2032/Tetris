//
//  LoginPresenter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import Foundation

protocol LoginPresenterProtocol: AnyObject {
    func login(login: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {

     weak var view: viewLoginProtocol?

    private lazy var network = NetworkWebTocken.getNetworkAutoresation()

    func login(login: String, password: String) {
        network.autoresation(str: "\(login) \(password)") { [weak self] input in
            if input == "Соеденение установленно" {
                DispatchQueue.main.async {
                self?.view?.showWaiting()
                }
            } else {
                DispatchQueue.main.async {
                    self?.view?.showInvalid(input)
                }
            }
        }
    }
}
