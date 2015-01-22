//
//  TerrainNode.swift
//  Settlers
//
//  Created by Carl Wieland on 12/22/14.
//  Copyright (c) 2014 Carl Wieland. All rights reserved.
//

import Cocoa
import SceneKit

class TerrainNode: SCNNode {
  
    let map:Map

    var geometryNodes:SCNNode? = nil
    init(map:Map){
        self.map = map
 
        
        super.init()

        reloadGeometry()

        

    }
    
     override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "layers"{
           //self.reloadGeometry()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    required init(coder adecoder:NSCoder){
        self.map = Map()
//        self.colors = [NSColor]()
        super.init(coder:adecoder)
    }
        
    func reloadGeometry(){
        self.geometry = nil
        loadGeometry(.Flattened)
    }

    enum RenderType{
        case Strips
        case Triangles
        case Flattened
    }
    
    let terrainHolder = SCNNode()
    func loadGeometry(type:RenderType){
        
        var rootNode:SCNNode? = nil
        let terrainMaterial = SCNMaterial()
        switch (type){
        case .Strips:
            var vertecies = [Vertex]()
            var triangles = [CInt]()
            let nodes = self.map.nodes
            for tile in nodes{
                vertecies.append(tile.vertex)
                triangles.append(CInt(tile.index))
                let index = tile.index + Int(map.width)
                
                triangles.append(CInt(index))
            
                if map.translateIndex(Int(tile.index)).x == map.width - 1{
                    triangles.append(CInt(tile.index + map.width))
                    triangles.append(CInt(tile.index + 1))
                }
                
            }
            let geometry = createStripGeometry(vertecies, triangles)
            geometry.materials = [terrainMaterial]
            self.geometry = geometry
        case .Triangles:
            rootNode = SCNNode()
            genTris(rootNode!)
            
        case .Flattened:
            rootNode = SCNNode()
            genTris(rootNode!)
            rootNode = rootNode?.flattenedClone()
            
        }
        if let root = rootNode{
            self.addChildNode(root)
        }
        
    }
    func genTris(root:SCNNode){
        let terrainMaterial = SCNMaterial()

        let nodes = self.map.nodes
        for tile in nodes{
            let pos = map.translateIndex(tile.index)
            if pos.x < (map.width - 1) && pos.y>0{
                var verts = tile.upTriangle
                var triangles:[CInt] = [0,2,1]
                
                let geometry = createTriangleGeometry(verts, triangles)
                geometry.materials = [terrainMaterial]
                let childNode = SCNNode(geometry: geometry)
                root.addChildNode(childNode)
                
                verts = tile.downTriangle
                triangles = [0,2,1]
                let downGeometry = createTriangleGeometry(verts, triangles)
                
                downGeometry.materials = [terrainMaterial]
                let downTriangle = SCNNode(geometry: downGeometry)
                
                root.addChildNode(downTriangle)
                
                
            }
        }
    }
}


