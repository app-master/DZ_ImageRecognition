//
//  ViewController.swift
//  DZ_ImageRecognition
//
//  Created by user on 01/04/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "imagesAR", bundle: nil)
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        let size = imageAnchor.referenceImage.physicalSize
        
        node.addChildNode(loadFakeImage(with: size))
        
    }
    
    func loadFakeImage(with size: CGSize) -> SCNNode {
        
        let geometry = SCNPlane(width: size.width, height: size.height)
        
        geometry.firstMaterial?.diffuse.contents = UIImage(named: "fakeDriverLicense")
        
        let node = SCNNode(geometry: geometry)
        
        node.eulerAngles.x = -.pi / 2
        
        node.runAction(SCNAction.sequence([
            SCNAction.wait(duration: 5),
            SCNAction.rotateBy(x: 0, y: 6.28, z: 0, duration: 1),
            SCNAction.fadeOut(duration: 2)]))
        
        
        return node
        
    }
    
     func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        let pFromColumn3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        return pFromColumn3
    }
    
}
