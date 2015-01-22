//
//  CameraController.swift
//  Settlers
//
//  Created by Carl Wieland on 12/22/14.
//  Copyright (c) 2014 Carl Wieland. All rights reserved.
//

import Cocoa
import SceneKit

class CameraController:NSObject {
    class func createController(scene:SCNScene)->CameraController{
        return CameraController(scene: scene)
    }
    let camera:SCNCamera
    let cameraNode:SCNNode
    
    var lookNode:SCNNode = SCNNode()
    var lookPoint:Vector3{
        get{
            return lookNode.position
        }
        set{
            lookNode.position = newValue
        }
    }
    
    var cameraPosition:Vector3{
        return cameraNode.position
    }
    
    init(scene:SCNScene){
        camera = SCNCamera()
        camera.automaticallyAdjustsZRange = true;

        cameraNode = SCNNode()
        cameraNode.position = Vector3(x: 0, y:50, z: 75)
        cameraNode.camera = camera
        cameraNode.constraints = [SCNLookAtConstraint(target: lookNode)]
        scene.rootNode.addChildNode(cameraNode)
        super.init()
        lookPoint = Vector3(x: 0, y:0, z: 0)


    }
    
    
    let minAngle:CGFloat = 10.0;
    let maxAngle:CGFloat = 85.0;
    let minZoom:CGFloat = 10.0;
    let maxZoom:CGFloat = 35000.0;

    
    var angleFromFloorToCamera:CGFloat{
        var cam = cameraNode.back;
        var camProjectionOntoFloor = Vector3(x:cam.x,y:cam.y, z:0);
    
        return Vector3.angle(camProjectionOntoFloor, to: cam);
    }
 
    func moveCamera(delta:Vector3){
        cameraNode.position = cameraNode.position + delta
    }
    
    func distanceToPoint(point:Vector3)->CGFloat{
        return (cameraNode.position - point).magnitude
    }
    func distanceToLookPoint()->CGFloat{
        return distanceToPoint(lookPoint)
    }
    func repositionCamera(newPosition:Vector3){
        moveCamera(newPosition - cameraNode.position);
    }
    
}
