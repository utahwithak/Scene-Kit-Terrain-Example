//
//  GameViewController.swift
//  SceneExample
//
//  Created by Carl Wieland on 1/21/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    var game = Game()
    override func awakeFromNib(){
        // create a new scene
        
        let world = SCNScene()
        
        // set the scene to the view
        self.gameView!.scene = world
        self.gameView!.cameraNode = CameraController.createController(world)
        self.gameView!.allowsCameraControl = true
        self.gameView!.autoenablesDefaultLighting = true
        self.gameView!.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor(calibratedRed: 0, green: 0, blue: 1, alpha: 0)
        
        

        
//        // retrieve the ship node
//        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
//        
        // animate the 3d object
//        let animation = CABasicAnimation(keyPath: "rotation")
//        animation.toValue = NSValue(SCNVector4: SCNVector4(x: CGFloat(0), y: CGFloat(1), z: CGFloat(0), w: CGFloat(M_PI)*2))
//        animation.duration = 3
//        animation.repeatCount = MAXFLOAT //repeat forever
//        ship.addAnimation(animation, forKey: nil)

        // set the scene to the view
//        
//        // allows the user to manipulate the camera
//        self.gameView!.allowsCameraControl = true
//        
//        self.gameView!.autoenablesDefaultLighting = true
//
//        // show statistics such as fps and timing information
//        self.gameView!.showsStatistics = true
//        
//        // configure the view
//        self.gameView!.backgroundColor = NSColor.blackColor()
        
        game.createRandomMap()
        var tNode = TerrainNode(map: game.map)
        self.gameView!.scene?.rootNode.addChildNode(tNode)
        
        
        
    }

}
