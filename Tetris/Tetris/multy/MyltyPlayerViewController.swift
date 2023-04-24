//
//  MyltyPlayerViewController.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 10.05.2022.
//

import UIKit
import ARKit

protocol MultyPlayerViewProtocol{
    func showNot(handel: @escaping (UIAlertAction) -> Void)
    func showEnd(i: Int, you: Int)
    func dis()
}

class SecondView: TetrisView {
    weak var view: MyltyPlayerViewController?

    init(view: MyltyPlayerViewController){
        self.view = view
    }

    func endGame(scope: Int) {
        view?.presenter.endGame(isFist: false)
    }

    func editScore(str: String) {
        DispatchQueue.main.async {
            self.view?.scoreLabelSecond.text = str
        }
    }


}

class MyltyPlayerViewController: ARViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigScoreLabel()
    }

    var presenter = MultyPlayerPresenter()
    private var alert: UIAlertController?
    private var secondView: SecondView?

    var secondPlayer: TetrisEngine?

    var arrSecond: [[SCNNode]] = [[]]

    let scoreLabelSecond : UILabel = {
        let control = UILabel()
        control.textColor = .white
        control.font = control.font.withSize(30)
        control.text = String(0)
        return control
    }()

    fileprivate func ConfigScoreLabel() {
        let backgrond = UIView()
        backgrond.backgroundColor = UIColor(red: 100, green: 0, blue: 0, alpha: 0.5)
        sceneView?.addSubview(backgrond)
        backgrond.translatesAutoresizingMaskIntoConstraints = false
        backgrond.topAnchor.constraint(equalTo: sceneView!.topAnchor, constant: 40).isActive = true
        backgrond.rightAnchor.constraint(equalTo: sceneView!.rightAnchor, constant: -10).isActive = true
        backgrond.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backgrond.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backgrond.layer.cornerRadius = 5
        backgrond.addSubview(scoreLabelSecond)
        scoreLabelSecond.translatesAutoresizingMaskIntoConstraints = false
        scoreLabelSecond.centerXAnchor.constraint(equalTo: backgrond.centerXAnchor).isActive = true
        scoreLabelSecond.centerYAnchor.constraint(equalTo: backgrond.centerYAnchor).isActive = true
    }


    @objc override func swipeToRight(sender: UISwipeGestureRecognizer){
        presenter.swipe(str: "right")
        tetris?.shiftToRight()
    }


    @objc override func swipeToLeft(sender: UISwipeGestureRecognizer){
        presenter.swipe(str: "left")
        tetris?.shiftToLeft()
    }

    @objc override func swipeToDown(sender: UISwipeGestureRecognizer){
        presenter.swipe(str: "down")
        tetris?.shiftDown()
    }


    @objc override func swipeToUp(sender: UISwipeGestureRecognizer){
        presenter.swipe(str: "up")
        tetris?.turn()
    }

    @objc override func checkAction(sender : UITapGestureRecognizer) {

        if tetris != nil || arr == [[]] {
            return
        }
        touchLabel.isHidden = true
        scoreLabel.text = "0"
        gameOverLabel.removeFromSuperview()
        secondView = SecondView(view: self)
        tetris = TetrisEngine(arr, view: self, generate: presenter)
        secondPlayer = TetrisEngine(arrSecond, view: secondView!, generate: presenter)
        presenter.engineFirst = tetris
        presenter.engineSecond = secondPlayer
        presenter.view = self

//        tetris?.start()
//        secondPlayer?.start()
        presenter.start()
    }

    override func createFloorNode(anchor: ARPlaneAnchor) -> [SCNNode] {
        var a : [SCNNode] = []
        var height: Float = 0
        let size = CGFloat(anchor.extent.x)/CGFloat((koef+10))

        for i in 0...1 {
            height = 0
            var countHeight = 0
            while countHeight < 20 {
                var row : [SCNNode] = []
                countHeight += 1
                var length = anchor.center.x - (Float(size) * 5) + (Float((Float(size) * 13)) * Float(i))
                var count  = 0
                while count < 10 {
                    count += 1

                    let geometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
                    let floorNode = SCNNode(geometry: geometry)
                    floorNode.position = SCNVector3(x: length, y: height, z: anchor.center.z)
                    floorNode.geometry?.firstMaterial?.isDoubleSided = true
                    floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                    floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                    floorNode.geometry?.firstMaterial?.isDoubleSided = true
                    floorNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
                    floorNode.name = "Plane"
                    a.append(floorNode)
                    row.append(floorNode)
                    length += Float(CGFloat(anchor.extent.x))/(koef+10)
                }
                if i == 0{
                    arr.append(row)
                } else {
                    arrSecond.append(row)
                }
                height += Float(CGFloat(anchor.extent.x))/(koef+10)
            }
        }
        return a
    }

    override func endGame(scope: Int) {
        presenter.endGame(isFist: true)
    }

}


extension MyltyPlayerViewController: MultyPlayerViewProtocol{
    func dis() {
        dismiss(animated: true)
        print("выход")
    }

    func showNot(handel: @escaping (UIAlertAction) -> Void) {
        alert = UIAlertController(title: "Соеденение с игроком потерянно", message: "Можете считать что вы победили))", preferredStyle: .alert)
        alert!.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: handel))
        self.present(alert!, animated: true, completion: nil)
    }

    func showEnd(i: Int, you: Int) {
        var str = "Вы победили!"
        if i < you {
            str = "Вы проиграли("
        }
        alert = UIAlertController(title: str, message: "Вы можете начать новую игру с этим соперником, или выйти в зал ожидания", preferredStyle: .alert)
        alert!.addAction(UIAlertAction(title: "Новая игра", style: .default, handler: { alert in
            self.tetris = nil
            self.secondPlayer = nil
            self.presenter.isFirstEnd = false
            self.presenter.isSecondEnd = false

            print("Новая игра")
        }))
        alert!.addAction(UIAlertAction(title: "Выйти", style: .default, handler: { alert in
            self.presenter.back()
            self.navigationController?.popViewController(animated: true)
            print("выйти")
        }))
        self.present(alert!, animated: true, completion: nil)
    }

}
