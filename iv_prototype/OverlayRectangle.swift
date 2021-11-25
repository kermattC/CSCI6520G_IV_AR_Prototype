//
//  OverlayRectangle.swift
//  iv_prototype
//
//  Created by Matt Chan on 2021-11-16.
//


import Foundation
import SceneKit
import ARKit

class OverlayRectangle: SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    func setup() {
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
        // use the transparent rectangle as the material for the plane
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"art.scnassets/rectangle.png")
        self.planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        
        // transform the plane node®
        // position will be the anchor's center in the x and z positions
        // rotation will make the rectangle appear flat on the horizontal plane
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        self.addChildNode(planeNode)
    }
    
    func update(anchor: ARPlaneAnchor) {
        // as the plane gets updated, the rectangle should be as well. this will be called when ARKit's didUpdate delegate gets called, increasing/decreasing the plane's extent
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
