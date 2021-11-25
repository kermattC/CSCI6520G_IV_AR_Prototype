//
//  ViewController+ARSCNViewDelegate.swift
//  iv_prototype
//
//  Created by Matt Chan on 2021-11-16.
//

import Foundation
import ARKit

extension ViewController: ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        let referenceImage = imageAnchor.referenceImage
        
        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        let image = UIImage(named: "iv_prototype_start.PNG")
        
        
        let planeMaterial = SCNMaterial()
        planeMaterial.locksAmbientWithDiffuse = true
        planeMaterial.diffuse.contents = image
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -Float.pi/2
        planeNode.geometry?.materials = [planeMaterial]
//        planeNode.addChildNode(planeNode)
        planeNode.name = "imageNode"
        
        
//        let backgroundPlaneMaterial = SCNMaterial()
//        backgroundPlaneMaterial.diffuse.contents = UIColor.systemCyan
//        let backgroundPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
//        let backgroundPlaneNode = SCNNode(geometry: backgroundPlane)
//        backgroundPlaneNode.eulerAngles.x = -Float.pi/2
//        backgroundPlaneNode.geometry?.materials = [backgroundPlaneMaterial]
//        backgroundPlaneNode.opacity = 0.35
//        planeNode.addChildNode(backgroundPlaneNode)
        

//        node.addChildNode(backgroundPlaneNode)
        node.addChildNode(planeNode)
    }
}
