//
//  GameView.swift
//  Settlers
//
//  Created by Carl Wieland on 12/19/14.
//  Copyright (c) 2014 Carl Wieland. All rights reserved.
//

import SceneKit

class GameView: SCNView {
    var cameraNode:CameraController? = nil
    
    override func mouseDragged(with theEvent: NSEvent) {
        guard let controller = cameraNode else {
            return
        }

        let viewPoint = convert(theEvent.locationInWindow, from: nil)
        let curHit = unprojectPoint(Vector3(x: viewPoint.x, y: viewPoint.y, z: 1))
        
        
        let prevPoint = NSMakePoint(viewPoint.x - theEvent.deltaX, viewPoint.y + theEvent.deltaY)
        let prevHit = unprojectPoint(Vector3(x: prevPoint.x, y: prevPoint.y, z: 1))
        
        var delta = prevHit - curHit
        delta.y = 0
        controller.lookPoint = controller.lookPoint + (delta)
        controller.moveCamera(delta)

    }


    override func scrollWheel(with theEvent: NSEvent) {
        guard let camNode = cameraNode else {
            return
        }

        let distanceToLookAt = camNode.distanceToLookPoint()
        let scale = theEvent.deltaY
        if scale == 0{
            return;
        }
        var distanceToMove = theEvent.deltaY
        
        
        if((distanceToLookAt - distanceToMove) > camNode.maxZoom){
            distanceToMove = distanceToLookAt - camNode.maxZoom;
        }
        else if((distanceToLookAt - distanceToMove) < camNode.minZoom){
            distanceToMove = distanceToLookAt - camNode.minZoom;
        }
        
        camNode.repositionCamera(Vector3.moveTowards(camNode.cameraPosition, target: camNode.lookPoint, maxDistanceDelta: distanceToMove))
    }
    
}
