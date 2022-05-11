//
//  WaitingRoomViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import UIKit

protocol WaitingRoomViewProtocol: AnyObject {
    func update()
    func showResponse(name: String)
    func showNotOnline()
    func showWaiting(username: String, handel: @escaping (UIAlertAction) -> Void )
    func dismissWaiting()
    func cancelResponse()
    func showGame(_ presenter: MultyPlayerPresenter)
}

class WaitingRoomViewController: UIViewController {

    private var alert: UIAlertController?

    private var presenter = WaitingRoomPresenter()

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var labelNotReqest: UILabel!
    @IBOutlet weak var online: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        button.backgroundColor = .systemBackground
        button.isHidden = true
        button.layer.cornerRadius = 10
        presenter.view = self
        online.isHidden = true
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }
    @IBAction func touchButton(_ sender: Any) {
        presenter.touchButton()
    }
    @IBAction func reloadButtomTouch(_ sender: Any) {
        presenter.networOnline()
    }
    @IBAction func cancelTouch(_ sender: Any) {
        button.isHidden = true
        labelNotReqest.isHidden = false
        presenter.cancelReqens()
    }
}

extension WaitingRoomViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = presenter.users[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }
}

extension WaitingRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.touchUser(index: indexPath.row)

    }
}


extension WaitingRoomViewController: WaitingRoomViewProtocol {
    func showGame(_ presenter: MultyPlayerPresenter) {
        let vc = MyltyPlayerViewController()
        vc.presenter = presenter
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func cancelResponse() {
        button.isHidden = true
        labelNotReqest.isHidden = false
    }

    func dismissWaiting() {
        alert?.dismiss(animated: true)
    }

    func showWaiting(username: String, handel: @escaping (UIAlertAction) -> Void ){
        alert = UIAlertController(title: "Ожидание игрока", message: "Игра запрошенна. \(username) должен принять запрос на игру", preferredStyle: .alert)
        alert!.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: handel))
        self.present(alert!, animated: true, completion: nil)
    }

    func showNotOnline() {
        tableView.reloadData()
        online.isHidden = false
    }

    func showResponse(name: String) {
        button.setTitle(name, for: .normal)
        button.dropShadow()
        labelNotReqest.isHidden = true
        button.isHidden = false
    }

    func update() {
        online.isHidden = true
        tableView.reloadData()
    }


}
