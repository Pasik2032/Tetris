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
  func cancelResponse()
}

final class WaitingRoomViewController: UIViewController {

  private var presenter: WaitingRoomPresenterProtocol
  public var username: String?

  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var labelNotReqest: UILabel!
  @IBOutlet weak var online: UILabel!

  init(presenter: WaitingRoomPresenterProtocol, nibName: String) {
    self.presenter = presenter
    super.init(nibName: nibName, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
    button.backgroundColor = .systemBackground
    button.isHidden = true
    button.layer.cornerRadius = 10
    online.isHidden = true
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.dataSource = self
  }

  override func viewWillDisappear(_ animated: Bool) {
    presenter.exit()
    super.viewWillDisappear(animated)
  }

  @IBAction func touchButton(_ sender: Any) {
    presenter.touchButton()
  }
  @IBAction func reloadButtomTouch(_ sender: Any) {
    presenter.reloadButton()
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
  func cancelResponse() {
    button.isHidden = true
    labelNotReqest.isHidden = false
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
