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
    //
    //    override func awakeFromNib() {
    ////        if let scene = self.scene{
    ////            let dirLight = SCNLight()
    ////            dirLight.type = SCNLightTypeDirectional
    ////            sunLight.light = dirLight
    ////            scene.rootNode.addChildNode(sunLight)
    ////        }
    //    }
    //    override func mouseDown(theEvent: NSEvent) {
    //
    //        // check what nodes are clicked
    ////        let p = self.convertPoint(theEvent.locationInWindow, fromView: nil)
    //    //    if let hitResults = self.hitTest(p, options: nil) {
    ////            // check that we clicked on at least one object
    ////            if hitResults.count > 0 && editing {
    ////                // retrieved the first clicked object
    ////                let result: AnyObject = hitResults[0]
    ////                for obj in hitResults as [SCNHitTestResult]{
    ////                    if let geometry = obj.node.geometry{
    ////                        if let terrainNode = terrain{
    ////                            if let layer = terrainNode.terrain.layerAtHeight(Int(obj.worldCoordinates.z)){
    ////
    ////                                var vec = obj.worldCoordinates
    ////                                vec.z = 0
    ////
    ////                                println("Adding Position\(vec)")
    ////                                layer.addPosition(vec)
    ////                            }
    ////                            terrainNode.reloadGeometry()
    ////
    ////                        }
    ////
    ////                    }
    ////                }
    ////            }
    ////        }
    //        super.mouseDown(theEvent)
    //
    //    }
    
    override func mouseDragged(theEvent: NSEvent) {
        
        if let controller = cameraNode{
            
            
            let viewPoint = self.convertPoint(theEvent.locationInWindow, fromView: nil)
            let curHit = self.unprojectPoint(Vector3(x: viewPoint.x, y: viewPoint.y, z: 1))
            
            
            var prevPoint = NSMakePoint(viewPoint.x - theEvent.deltaX, viewPoint.y + theEvent.deltaY)
            let prevHit = self.unprojectPoint(Vector3(x: prevPoint.x, y: prevPoint.y, z: 1))
            
            var delta = prevHit - curHit
            delta.y = 0
            controller.lookPoint = controller.lookPoint + (delta)
            controller.moveCamera(delta)
            
        }
    }
    //
    //
    //    override func rightMouseDown(theEvent:NSEvent){
    //        if let controller = cameraNode{
    //            let viewPoint = self.convertPoint(theEvent.locationInWindow, fromView: nil)
    //            println("Converted:\(self.unprojectPoint(Vector3(x: viewPoint.x, y: viewPoint.y, z: 0)))")
    //        }
    //
    //    }
    //    override func rightMouseDragged(theEvent: NSEvent) {
    //        if let controller = cameraNode{
    //            let viewPoint = self.convertPoint(theEvent.locationInWindow, fromView: nil)
    //            var prevPoint = NSMakePoint(viewPoint.x - theEvent.deltaX, viewPoint.y + theEvent.deltaY)
    //            let curHit = self.unprojectPoint(Vector3(x: viewPoint.x, y: viewPoint.y, z: 0))
    //            let prevHit = self.unprojectPoint(Vector3(x: prevPoint.x, y: prevPoint.y, z: 0))
    //
    //            var delta = prevHit - curHit
    //            println("Delta\(delta)")
    //                delta.y = 0
    //                controller.lookPoint = controller.lookPoint + (delta * 10)
    //                controller.moveCamera(delta)
    //        }
    //
    //    }
    //
    //
    override func scrollWheel(theEvent: NSEvent) {
        if let camNode = cameraNode{
            let distanceToLookAt = camNode.distanceToLookPoint()
            var scale = theEvent.deltaY
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
            
            camNode.repositionCamera(Vector3.moveTowards(camNode.cameraPosition, target: camNode.lookPoint, maxDistanceDelta: distanceToMove));
            
        }
    }
    
}
