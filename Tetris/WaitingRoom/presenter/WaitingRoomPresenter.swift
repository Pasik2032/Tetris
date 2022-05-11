//
//  WaitingRoomPresenter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import UIKit

protocol WaitingRoomPresenterProtocol {
    var users: [UserModel] {get set}
    func touchUser(index: Int)
    func touchButton()
    func networOnline()
    func cancelReqens()
}

class WaitingRoomPresenter: WaitingRoomPresenterProtocol {

    func cancelReqens() {
        self.network.cancel()
    }

    func touchButton() {
        network.status = .ready
        network.request(str: "ok") { input in
            if input == "start" {
                self.network.status = .play
                let vc = MultyPlayerPresenter()
                DispatchQueue.main.async {
                    self.view?.dismissWaiting()
                    self.view?.showGame(vc)
                }
                print("game!")
                
            } else {
                print("Error \(input)")
            }
        }
    }

    func touchUser(index: Int) {
        network.status = .ready
        network.request(str: "response \(users[index].username)") { input in
            if input == "start" {
                self.network.status = .play
                let vc = MultyPlayerPresenter()
                DispatchQueue.main.async {
                    self.view?.dismissWaiting()
                    self.view?.showGame(vc)
                }
                print("game!")
            } else {
                self.network.status = .online
                DispatchQueue.main.async {
                    self.view?.dismissWaiting()
                }
            }
        }

        view?.showWaiting(username: users[index].username, handel: { action in
            switch action.style {
            case .cancel:
                print("cancel")
                self.network.status = .online
                self.network.cancel()
                break
            default :
                print("error")
            }
        })

    }



    public weak var view: WaitingRoomViewProtocol?
    public var users: [UserModel] = []
    private lazy var network = NetworkWebTocken.getResponseAndRequest()
    private lazy var networkOnline = NetworkAPI.getNetworkOnline()

    init() {
        network.status = .online
        networkResponse()
        networOnline()
    }



    public func networOnline(){
        networkOnline.getOnline { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users ?? []
                    if self.users.isEmpty {
                        self.view?.showNotOnline()
                    } else{
                        self.view?.update()
                    }
                case .failure(_):
                    print("errr")
                }
            }

        }
    }

    private func networkResponse() {
        network.response { input in
            let a = input.split(separator: " ")
            if a[0] == "request" {
                DispatchQueue.main.async {
                    self.view?.showResponse(name: String(a[1]))
                }
            } else {
                self.network.status = .online
                DispatchQueue.main.async {
                    self.view?.cancelResponse()
                }
                print("error \(a)")
            }
        }
    }

}


