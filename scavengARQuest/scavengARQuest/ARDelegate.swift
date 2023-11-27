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
    
    func setARView(_ arView: ARSCNView) {
        self.arView = arView
        
        //configuration.planeDetection = .horizontal
        
        arView.delegate = self
        arView.scene = SCNScene(named: "ship.scn")!
        arView.allowsCameraControl = true
        
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
