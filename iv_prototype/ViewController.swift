//
//  ViewController.swift
//  iv_prototype
//
//  Created by Matt Chan on 2021-11-16.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    // array of planes detected. used for the overlay rectangles of detected planes
    var planes = [OverlayRectangle]()
    
    var targetFlip: Int = 0

    // add a button
    @IBOutlet var superAwesomeButton: UIButton!
    @IBOutlet var targetChangeButton: UIButton!

    
    // counter that will be flipped
    var imageCounter: Int = 0
    
    @IBOutlet var sceneView: ARSCNView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        setupButtons()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func addGif(name: String, number: Int) -> SCNNode {
        let gifNode = SCNNode()
        let gifPlane = SCNPlane(width: 0.00025, height: 0.0005)
        let gifImage = UIImage.gifImageWithName(name)
        let gifImageView = UIImageView(image: gifImage)
        gifImageView.layer.isDoubleSided = true
        gifPlane.firstMaterial?.diffuse.contents = gifImageView
        gifNode.geometry = gifPlane
        if (number == 0){
            gifNode.position = SCNVector3(-0.000475, -0.001, -0.00235)
            gifNode.eulerAngles = SCNVector3(x: -Float.pi/6, y: 0.0, z: -Float.pi)
            gifNode.name = "arrowNode0"
        } else if (number == 1){
            gifNode.position = SCNVector3(0.000000625, -0.001, -0.00165)
            gifNode.eulerAngles = SCNVector3(x: -Float.pi/6, y: 0.0, z: Float.pi/2)
            gifNode.name = "arrowNode1"
        }
        return gifNode
    }
    
    private func setupButtons(){
        superAwesomeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.75, y: UIScreen.main.bounds.height * 0.5, width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.075))
        superAwesomeButton.backgroundColor = .clear
        superAwesomeButton.layer.borderWidth = 1.0
        superAwesomeButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7).cgColor
        superAwesomeButton .layer.cornerRadius = 5.0
        superAwesomeButton.setTitle("Press Me", for: .normal)
        superAwesomeButton.setTitleColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: UIControl.State.normal)
        superAwesomeButton.addTarget(self, action: #selector(specialTing(_:)), for: .touchUpInside)
        
        targetChangeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.75, y: UIScreen.main.bounds.height * 0.6, width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.075))
        targetChangeButton.backgroundColor = .clear
        targetChangeButton.layer.borderWidth = 1.0
        targetChangeButton.layer.borderColor = UIColor(red: 4.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 0.7).cgColor
        targetChangeButton .layer.cornerRadius = 5.0
        targetChangeButton.setTitle("Target", for: .normal)
        targetChangeButton.setTitleColor(UIColor(red: 4.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: UIControl.State.normal)
        targetChangeButton.addTarget(self, action: #selector(changeTing(_:)), for: .touchUpInside)
        
        self.sceneView.addSubview(superAwesomeButton)
        self.sceneView.addSubview(targetChangeButton)
    }
    
    @objc func specialTing(_ sender: UIButton!){
        let newImage: String = "iv_prototype_" + String(imageCounter)
        print("new image: ", newImage)
        modifyImage(imageName: newImage)
        imageCounter += 1
    
        // set things so that when the image is at the part where it tells the user to follow the guides, the arrow gif will appear. the step after will remove it
        if (imageCounter == 8) {
            sceneView.scene.rootNode.addChildNode(addGif(name: "blue_arrow", number: 0))
            sceneView.scene.rootNode.addChildNode(addGif(name: "blue_arrow", number: 1))
            
            let targetImage = UIImage(named: "target")
            let targetPlane = SCNPlane(width: 0.000125, height: 0.000125)
            let targetMaterial = SCNMaterial()
            targetMaterial.locksAmbientWithDiffuse = true
            targetMaterial.diffuse.contents = targetImage
            targetMaterial.isDoubleSided = true
            
            let targetNode0 = SCNNode(geometry: targetPlane)
            targetNode0.geometry?.materials = [targetMaterial]
            targetNode0.position = SCNVector3(-0.0004, -0.001, -0.00195)
            targetNode0.eulerAngles.x = -Float.pi/1.75
            targetNode0.name = "targetNode0"
            targetNode0.opacity = 0.0
            
            let targetNode1 = SCNNode(geometry: targetPlane)
            targetNode1.geometry?.materials = [targetMaterial]
            targetNode1.position = SCNVector3(-0.00018, -0.001, -0.00175)
            targetNode1.eulerAngles.x = -Float.pi/1.75
            targetNode1.name = "targetNode1"
            targetNode1.opacity = 0.0
            
            sceneView.scene.rootNode.addChildNode(targetNode0)
            sceneView.scene.rootNode.addChildNode(targetNode1)
            
        }
        if (imageCounter == 9){
            let arrowNode0 = self.sceneView.scene.rootNode.childNode(withName: "arrowNode0", recursively: true)
            let arrowNode1 = self.sceneView.scene.rootNode.childNode(withName: "arrowNode1", recursively: true)
            let targetNode0 = self.sceneView.scene.rootNode.childNode(withName: "targetNode0", recursively: true)
            let targetNode1 = self.sceneView.scene.rootNode.childNode(withName: "targetNode1", recursively: true)

            arrowNode0?.removeFromParentNode()
            arrowNode1?.removeFromParentNode()
            targetNode0?.removeFromParentNode()
            targetNode1?.removeFromParentNode()

        }
        
        if (imageCounter == 10){
    
            let xImage = UIImage(named: "red_x")
            let xPlane = SCNPlane(width: 0.000125, height: 0.000125)
            let xMaterial = SCNMaterial()
            xMaterial.locksAmbientWithDiffuse = true
            xMaterial.diffuse.contents = xImage
            xMaterial.isDoubleSided = true
            
            let xNode = SCNNode(geometry: xPlane)
            xNode.geometry?.materials = [xMaterial]
            xNode.position = SCNVector3(-0.0004, -0.001, -0.00195)
            xNode.name = "xNode"
            
            
            sceneView.scene.rootNode.addChildNode(xNode)
        }
        if (imageCounter == 11){
            let xNode = self.sceneView.scene.rootNode.childNode(withName: "xNode", recursively: true)
            xNode?.removeFromParentNode()
            
            let checkImage = UIImage(named: "green_check")
            let checkPlane = SCNPlane(width: 0.000125, height: 0.000125)
            let checkMaterial = SCNMaterial()
            checkMaterial.locksAmbientWithDiffuse = true
            checkMaterial.diffuse.contents = checkImage
            checkMaterial.isDoubleSided = true
            
            let checkNode = SCNNode(geometry: checkPlane)
            checkNode.geometry?.materials = [checkMaterial]
            checkNode.position = SCNVector3(-0.0004, -0.001, -0.00195)
            checkNode.name = "checkNode"
            sceneView.scene.rootNode.addChildNode(checkNode)
        }
        if (imageCounter == 12){
            let checkNode = self.sceneView.scene.rootNode.childNode(withName: "checkNode", recursively: true)
            checkNode?.removeFromParentNode()
        }
    }
    
    @objc func changeTing(_ sender: UIButton!){
        targetFlip += 1
        let arrowNode0 = self.sceneView.scene.rootNode.childNode(withName: "arrowNode0", recursively: true)
        let arrowNode1 = self.sceneView.scene.rootNode.childNode(withName: "arrowNode1", recursively: true)
        let targetNode0 = self.sceneView.scene.rootNode.childNode(withName: "targetNode0", recursively: true)
        let targetNode1 = self.sceneView.scene.rootNode.childNode(withName: "targetNode1", recursively: true)
        
        if (targetFlip == 1){
            arrowNode0?.opacity = 0.0
            arrowNode1?.opacity = 0.0
            targetNode0?.opacity = 100.0
            targetNode1?.opacity = 100.0
        } else if (targetFlip == 2){
            arrowNode0?.opacity = 0.0
            arrowNode1?.opacity = 0.0
            targetNode0?.opacity = 0.0
            targetNode1?.opacity = 0.0
        } else if (targetFlip == 3){
            arrowNode0?.opacity = 100.0
            arrowNode1?.opacity = 1000.0
            targetNode0?.opacity = 0.0
            targetNode1?.opacity = 0.0
        }
    }
    
    func modifyImage(imageName: String){	
        
        let imageNode = self.sceneView.scene.rootNode.childNode(withName: "imageNode", recursively: true)
        let image = UIImage(named: imageName)
        let planeMaterial = SCNMaterial()
        planeMaterial.locksAmbientWithDiffuse = true
        planeMaterial.diffuse.contents = image
        imageNode?.geometry?.materials = [planeMaterial]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else{
            print("No images available")
            return
        }
        
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1

        // Run the view's session
        sceneView.session.run(configuration)
        	
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
