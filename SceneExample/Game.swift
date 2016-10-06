//
//  Game.swift
//  Settlers
//
//  Created by Carl Wieland on 1/6/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Cocoa

@objc(Game)
class Game: NSObject {
    var map: Map = Map()

    func createRandomMap() {
        let generator = TerrainGenerator(size: 64)
        generator.runAlgorithm(map)
    }
}
