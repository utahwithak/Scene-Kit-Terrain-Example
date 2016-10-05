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

    override func awakeFromNib() {
        let world = SCNScene()
        
        // set the scene to the view
        gameView.scene = world
        gameView.cameraNode = CameraController.createController(world)
        gameView.allowsCameraControl = true
        gameView.autoenablesDefaultLighting = true
        gameView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        gameView.showsStatistics = true
        
        // configure the view
        gameView.backgroundColor = NSColor(calibratedRed: 0, green: 0, blue: 1, alpha: 0)

        game.createRandomMap()
        let tNode = TerrainNode(map: game.map)
        gameView.scene?.rootNode.addChildNode(tNode)
        
    }

}
