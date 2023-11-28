//
//  ARDelegate.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/27/23.
//

import Foundation
import ARKit
import UIKit

class ARDelegate: NSObject, ARSCNViewDelegate, ObservableObject {
    private var arView: ARSCNView?
    private let store = ScavengarStore.shared

    func setARView(_ arView: ARSCNView) {
        self.arView = arView
        
        //configuration.planeDetection = .horizontal
        
        arView.delegate = self
        arView.scene = SCNScene()
        arView.allowsCameraControl = true
        arView.autoenablesDefaultLighting = true

        print(store.filename)
        let model = SCNScene(named: store.filename)!
        var modelNode = model.rootNode.childNodes[0]
        
        print(model.rootNode.childNodes)
        print(modelNode.childNodes)
        
        if (store.filename == "cube.scn"){
            modelNode.position = SCNVector3(0,0,-0.2)

        } else if (store.filename == "gavel.scn") {
            modelNode =  model.rootNode.childNodes[0].childNodes[0].childNodes[0]
            print(modelNode)
            modelNode.position = SCNVector3(0,0,-3)
        } else if (store.filename == "football.scn") {
            modelNode =  model.rootNode.childNodes[0].childNodes[0].childNodes[0]
            print(modelNode)
            modelNode.position = SCNVector3(0,0,-3)
        } else if (store.filename == "pizza.scn") {
            modelNode =  model.rootNode.childNodes[0].childNodes[0].childNodes[0]
            print(modelNode)
            modelNode.position = SCNVector3(0,0,-0.1)
        } else {
            modelNode.position = SCNVector3(0,0,-4)

        }
        
        
        arView.scene.rootNode.addChildNode(modelNode)
        
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
    }
    
    /*
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("camera did change \(camera.trackingState)")
        switch camera.trackingState {
        case .limited(_):
            message = "tracking limited"
        case .normal:
            message =  "tracking ready"
        case .notAvailable:
            message = "cannot track"
        }
    }
     */
    
}
