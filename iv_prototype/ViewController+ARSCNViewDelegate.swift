//
//  ViewController+ARSCNViewDelegate.swift
//  iv_prototype
//
//  Created by Matt Chan on 2021-11-16.
//

import Foundation
import ARKit

extension ViewController: ARSCNViewDelegate{
    
    // uses the ARSCNViewDelegate to add the starting image when the reference image is detected
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
        planeNode.name = "imageNode"
        
        node.addChildNode(planeNode)
    }
}
