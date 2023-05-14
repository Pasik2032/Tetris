//
//  ARAdapter.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 13.05.2023.
//

import Foundation
import ARKit
import SceneKit

protocol ARAdapterDelegate {
  var games: [Game] { get set }
  func rendererScene()
}

final class ARAdapter: NSObject {

  var sceneView: ARSCNView
  var presenter: ARAdapterDelegate

  let configuration: ARWorldTrackingConfiguration = {
    let controll = ARWorldTrackingConfiguration()
    controll.planeDetection = .horizontal
    return controll
  }()

  init(sceneView: ARSCNView, presenter: ARAdapterDelegate) {
    self.sceneView = sceneView
    self.presenter = presenter
    super.init()
    sceneView.delegate = self
  }

  // the size of the field depends (inversely proportional)
  let koef: Float = 20

  func config() {
    sceneView.session.run(configuration)
  }

  func pause() {
    sceneView.session.pause()
  }


  func createFloorNode(anchor: ARPlaneAnchor, games: inout [Game]) -> [SCNNode] {

    var a : [SCNNode] = []
    var height: Float = 0
    let size = CGFloat(anchor.extent.x)/CGFloat((koef+10))

    for i in 0..<games.count {
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
        games[i].field.append(row)
        height += Float(CGFloat(anchor.extent.x))/(koef+10)
      }
    }
    return a
  }
}


extension ARAdapter: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
    let planeNode = createFloorNode(anchor: planeAnchor, games: &presenter.games)
    for nodes in planeNode {
      node.addChildNode(nodes)
    }
    presenter.rendererScene()
  }
}
