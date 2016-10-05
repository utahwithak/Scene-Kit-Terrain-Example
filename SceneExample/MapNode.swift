//
//  MapNode.swift
//  Settlers
//
//  Created by Carl Wieland on 1/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import SceneKit

// swiftlint:disable variable_name
let TR_W:GLfloat = 53;
let TR_H:GLfloat = 29;


let HEIGHT_FACTOR:GLfloat = 5;
// swiftlint:enable variable_name

var colorsMap = [String:[NSColor]]()

func  colorsFromPallet(_ palletName:NSString) -> [NSColor] {
    if let colors = colorsMap[palletName as String] {
        return colors
    }
    else{
        var loadedColors = [NSColor()]
        if let image = NSImage(named:palletName as String){
            if let bitmap = NSBitmapImageRep(data:image.tiffRepresentation!){
                for x in 0..<Int(bitmap.size.width){
                    if let color = bitmap.colorAt(x: x, y: 0){
                        if let convertedColor = color.usingColorSpace(NSColorSpace.genericRGB){
                            loadedColors.append(convertedColor)
                        }
                    }
                    
                }
            }
        }
        colorsMap[palletName as String] = loadedColors
        return loadedColors
    }
}

@objc(MapNode)
class MapNode:NSObject {

    var height: Int = 0
    var index: Int = 0
    var map:Map? = nil
    
    var left: MapNode? = nil
     var upLeft: MapNode? = nil
     var upRight: MapNode? = nil
     var right: MapNode? = nil
     var downLeft: MapNode? = nil
     var downRight: MapNode?  = nil
    
    
    var calculatedPosition:Float3? = nil
    var position:Float3{
        if calculatedPosition != nil{
            return calculatedPosition!
        }
        let pos = map!.translateIndex(Int(self.index))
        calculatedPosition = Float3(x: GLfloat(pos.x) * TR_W + (pos.y % 2 == 0 ? 0 : TR_W * 0.5) , y:GLfloat( self.height) * HEIGHT_FACTOR, z: GLfloat(pos.y) * TR_H)

        return calculatedPosition!
    }

    var calculatedVert:Vertex? = nil
    var vertex:Vertex{
        if calculatedVert != nil{
            return calculatedVert!
        }
        let position = self.position
        let normal = self.normal
        _ = Float2(s:0, t:0)
        let colors = colorsFromPallet("terrainColors")
        
        var r:CGFloat = 1
        var g:CGFloat = 1
        var b:CGFloat = 1
        var a:CGFloat = 1
        
        let colorIndex:Int = max(min(Int(127+self.height),colors.count-1),0)
        let color = colors[colorIndex]
        if let converted = color.usingColorSpace(NSColorSpace.genericRGB){
            converted.getRed(&r, green: &g, blue: &b, alpha: &a)
        }
        
        calculatedVert = Vertex(position: position, normal: normal/*, tcoord: tCoord*/, color: Float3(x: GLfloat(r), y: GLfloat(g), z: GLfloat(b)))
        return calculatedVert!
    }
//
//    //             A_____ B____ X
//    //            /\    /\    /
//    //           /  \  /  \  /
//    //        C /____\/_D__\/ E
//    //          \    /\    /
//    //           \  /  \  /
//    //         Y  \/_F__\/ G
//    
    var calculatedNorm:Float3? = nil
    var normal:Float3{
        if calculatedNorm != nil{
            return calculatedNorm!
        }
        //Calculates the average normal of all the triangles surrounding it.
        var triNorms = [Float3]()
        
        var A = self.upRight!
        var C = self.right!

        var normal = calculateVectorNormal(A.position, B: self.position, C: C.position)

        if self.index < self.right!.index{
            triNorms.append(normal)

            A = self.right!
            C = self.downRight!
            normal = calculateVectorNormal(A.position, B: self.position, C: C.position)
            triNorms.append(normal)
        }
        
        if self.index < self.upLeft!.index{
            A = self.upLeft!
            C = self.upRight!
            normal = calculateVectorNormal(A.position, B: self.position, C: C.position)
            triNorms.append(normal)
        }
        
        if self.left!.index < self.index{
            A = self.left!
            C = self.upLeft!
            normal = calculateVectorNormal(A.position, B: self.position, C: C.position)
            triNorms.append(normal)
            
            A = self.downLeft!
            C = self.left!
            normal = calculateVectorNormal(A.position, B: self.position, C: C.position)
            triNorms.append(normal)
          
        }
        
        if self.index > self.map!.width{
            A = self.downRight!
            C = self.downLeft!
            normal = calculateVectorNormal(A.position, B: self.position, C: C.position)
            triNorms.append(normal)
        }
                
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        var z:CGFloat = 0.0
        
        for norm in triNorms{
            x = x + CGFloat(norm.x)
            y = y + CGFloat(norm.y)
            z = z + CGFloat(norm.z)
            
        }
        x /= CGFloat(triNorms.count)
        y /= CGFloat(triNorms.count)
        z /= CGFloat(triNorms.count)
        var sum = SCNVector3Make(x, y, z)
        sum = sum.normalized
        //             A_____ B____ X
        //            /\    /\    /
        //           /  \  /  \  /
        //        C /____\/_D__\/ E
        //          \    /\    /
        //           \  /  \  /
        //         Y  \/_F__\/ G
        
        calculatedNorm =  sum.toFloat3()
        return calculatedNorm!
    }

    var upTriangle:[Vertex]{
        let A = downRight!.vertex
        let B = vertex
        let C = downLeft!.vertex
        
        /* A.tcoord = Float2(s: 1, t: tileIndex)
        B.tcoord = Float2(s: 0, t: tileIndex + stepVal)
        C.tcoord = Float2(s: 0, t: tileIndex)*/
        return [A,B,C]
    }

    var downTriangle:[Vertex]{
        let A = right!.vertex
        let B = vertex
        let C = downRight!.vertex
        /*        A.tcoord = Float2(s: 1, t: tileIndex + stepVal)
        B.tcoord = Float2(s: 0, t: tileIndex + stepVal)
        C.tcoord = Float2(s: 1, t: tileIndex)*/
        return [A,B,C]
        
    }

    
    override var description: String {
        return "[index:\(index) height:\(height)]"
    }
    
    override var debugDescription:String{
        return description
    }

}
