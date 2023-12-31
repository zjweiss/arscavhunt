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
        
        if (store.ar_unwrap){
            modelNode =  model.rootNode.childNodes[0].childNodes[0].childNodes[0]
        }
        
        modelNode.position = SCNVector3(0,0,store.ar_displacement)        
        
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
