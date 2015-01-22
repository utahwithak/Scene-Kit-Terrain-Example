//
//  TerrainGenerator.swift
//  Settlers
//
//  Created by Carl Wieland on 12/29/14.
//  Copyright (c) 2014 Carl Wieland. All rights reserved.
//

import AppKit
import CoreData

class TerrainGenerator{
    var values:[Double]
    let width:Int
    let height:Int

    init(size:Int){
        width = size
        height = size
        values = Array<Double>(count: size*size, repeatedValue: 0)
    }
    
    var minVal:Double = 100000
    var maxVal:Double = -1000000
    

    func runAlgorithm(map:Map){

        var samplesize = 32;
        println("Generating with feature size:\(samplesize)")

        var scale:Double = 2
        
        while (samplesize > 1)
        {
            
            println("Running Diamond Square Sample Size:\(samplesize)")
            diamondSquare(samplesize, scale: scale);
            samplesize /= 2;
            scale /= 2.0;
        }
        saveToMap(map, scale:15)
    }
    
    
    func  adjustHeight(h1:Double, h2:Double,x:Int,y:Int)->Bool
    {
        if (abs(h1 - h2) > 50) {
            setSample(x, y: y, value:  h1 + ((h1 < h2) ? 50 : -50));
            return true;
        }
    
        return false;
    }
    
    /* Ensure that map heights of adjacent fields are not too far apart. */

    func generateFromImage(image:NSBitmapImageRep,map:Map){
        for y in 0..<height{
            for x in 0..<width{
                if let color = image.colorAtX(x, y: y){
                    if let convertedColor = color.colorUsingColorSpace(NSColorSpace.genericGrayColorSpace()){
                        let white = convertedColor.whiteComponent
                        let val = Double(round(white*256) - 127)
                        setSample(x, y: y, value: val)
                    }
                }
                
            }
        }
        saveToMap(map)
    }
    

    func saveToMap(map:Map, scale:Double = 1){
        map.width = self.width
        map.height = self.height
        var sortedTiles = [MapNode]()
        for x in 0..<values.count{
            let val = values[x]
            let newTile = MapNode()
            newTile.map = map
            newTile.index = x
            newTile.height = Int(val * scale)
            sortedTiles.append(newTile)
        }
        
        for index in 0..<sortedTiles.count{
            let current = sortedTiles[index]
            let leftInds = map.moveIndex(index, dir: .Left)
            var other = sortedTiles[map.indexOf(x: leftInds.x , y: leftInds.y) ]
            current.left = other
            other.right = current
            
            let upLeft = map.moveIndex(index, dir: .UpLeft)
            other = sortedTiles[map.indexOf(x: upLeft.x , y: upLeft.y) ]
            current.upLeft = other
            other.downRight = current
           
            let upRight = map.moveIndex(index, dir: .UpRight)
            let translated = map.indexOf(x:  upRight.x , y: upRight.y)
            let upRightNode =  sortedTiles[translated]
            current.upRight = upRightNode
            upRightNode.downLeft = current

        }
        map.nodes = sortedTiles
        
    }
    
    func sample(x:Int, y:Int)->Double
    {
        return values[(x & (width - 1)) + (y & (height - 1)) * width];
    }

    func setSample(x:Int, y:Int,  value:Double)
    {
        if value < minVal{
            minVal = value
        }
        
        if value > maxVal{
            maxVal = value
        }

        values[(x & (width - 1)) + (y & (height - 1)) * width] = value;
    }
    
    
    func sampleSquare(x:Int, y:Int,  size:Int,  value:Double)
    {
        let hs = size / 2
        let a = sample(x - hs, y: y - hs)
        let b = sample(x + hs, y: y - hs)
        let c = sample(x - hs, y: y + hs)
        let d = sample(x + hs, y: y + hs)
        
        setSample(x, y: y, value: ((a + b + c + d) / 4.0) + value)
    
    }
    
    func sampleDiamond( x:Int,  y:Int,  size:Int, value:Double)
    {
        let  hs = size / 2;
    
        let a = sample(x - hs, y: y);
        let b = sample(x + hs, y: y);
        let c = sample(x, y: y - hs);
        let d = sample(x, y: y + hs);
        
        setSample(x, y: y, value: ((a + b + c + d) / 4.0) + value);
    }
    
    func frand()->Double{
        return Double(arc4random_uniform(3))-1
    }
    func diamondSquare( stepsize:Int,  scale:Double)
    {
    
        var halfstep = stepsize / 2;
    
        for var y = halfstep; y < height + halfstep; y += stepsize {
            for var x = halfstep; x < width + halfstep; x += stepsize{
                let val = frand()
                sampleSquare(x, y: y, size: stepsize, value:val  * scale);
            }
        }
    
        for var y = 0; y < height; y += stepsize {
            for var x = 0; x < width; x += stepsize {
                sampleDiamond(x + halfstep, y: y, size: stepsize, value:frand() * scale);
                sampleDiamond(x, y: y + halfstep, size: stepsize, value:frand() * scale);
            }
        }
    
    }
    
}
