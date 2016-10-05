//
//  Utils.swift
//  Settlers
//
//  Created by Carl Wieland on 12/19/14.
//  Copyright (c) 2014 Carl Wieland. All rights reserved.
//

import Foundation
import SceneKit

public extension SCNNode{
    var forward:SCNVector3{
        return self.rotation * Vector3.forward;
    }
    var right:SCNVector3{
        return self.rotation * Vector3.right;
    }
    var left:SCNVector3{
        return self.rotation * Vector3.left;
    }
    var back:SCNVector3{
        return self.rotation * Vector3.back;
        
    }
    var up:SCNVector3{
        return self.rotation * Vector3.up;
    }
    var down:SCNVector3{
        return self.rotation * Vector3.down;
        
    }
}

typealias Vector4 = SCNVector4

func degToRad(_ deg:CGFloat)->CGFloat{
    return (deg / 180.0) * CGFloat(M_PI)
    
}
let rad2Deg = CGFloat(180.0 / M_PI)
let deg2Rad = CGFloat(M_PI / 180.0)

func clamp<T:Comparable>(_ val:T, min:T,max:T)->T{
    return val < min ? min : (val > max ? max:val)
}

func * (rotation:Vector4, point:Vector3)->Vector3{
        let num = rotation.x * 2
        let num2 = rotation.y * 2
        let num3 = rotation.z * 2
        let num4 = rotation.x * num
        let num5 = rotation.y * num2
        let num6 = rotation.z * num3
        let num7 = rotation.x * num2
        let num8 = rotation.x * num3
        let num9 = rotation.y * num3
        let num10 = rotation.w * num
        let num11 = rotation.w * num2
        let num12 = rotation.w * num3
        let result = Vector3(x:(1 - (num5 + num6)) * point.x + (num7 - num12) * point.y + (num8 + num11) * point.z,
                         y:(num7 + num12) * point.x + (1 - (num4 + num6)) * point.y + (num9 - num10) * point.z,
                         z:(num8 - num11) * point.x + (num9 + num10) * point.y + (1 - (num4 + num5)) * point.z)
        return result;
}

public struct Float3:CustomDebugStringConvertible, CustomStringConvertible {
    public init(x:GLfloat, y:GLfloat, z:GLfloat){
        self.x = x
        self.y = y
        self.z = z
    }
    public var x, y, z: GLfloat
    public var description:String{
            return "[X:\(x) Y:\(y) Z:\(z)]"
    }
    public var debugDescription: String {
            return description
    }

}
struct Float2 {
    var s, t: GLfloat
}
struct Vertex {
    var position: Float3
    var normal: Float3
//    var tcoord: Float2
    var color: Float3

    mutating func setNormal(_ newNorm:Float3){
        normal = newNorm
    }
    mutating func setColor(_ newColor:NSColor){
        var r:CGFloat = 1
        var g:CGFloat = 1
        var b:CGFloat = 1
        var a:CGFloat = 1
        
        newColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        color.x = GLfloat(r)
        color.y = GLfloat(g)
        color.z = GLfloat(b)
    }
}
//
//var vertices: [Vertex] = [ /* ... vertex data ... */ ]
func createStripGeometry(_ vertices:[Vertex], triangles:[CInt])->SCNGeometry{

    let data = Data(bytes: UnsafeRawPointer(vertices), count: vertices.count * MemoryLayout<Vertex>.size)

    let vertexSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.vertex,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<GLfloat>.size,
        dataOffset: 0, // position is first member in Vertex
        dataStride: MemoryLayout<Vertex>.size)

    let normalSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.normal,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<GLfloat>.size,
        dataOffset: MemoryLayout<Float3>.size, // one Float3 before normal in Vertex
        dataStride: MemoryLayout<Vertex>.size)

//    let tcoordSource = SCNGeometrySource(data: data,
//        semantic: SCNGeometrySourceSemanticTexcoord,
//        vectorCount: vertices.count,
//        floatComponents: true,
//        componentsPerVector: 2,
//        bytesPerComponent: sizeof(GLfloat),
//        dataOffset: 2 * sizeof(Float3), // 2 Float3s before tcoord in Vertex
//        dataStride: sizeof(Vertex))
    let colorSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.color,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<GLfloat>.size,
        dataOffset: (2 * MemoryLayout<Float3>.size), // 2 Float3s before tcoord in Vertex
        dataStride: MemoryLayout<Vertex>.size)

    let triData = Data(bytes: UnsafeRawPointer(triangles), count: MemoryLayout<CInt>.size*triangles.count)

    let geometryElement = SCNGeometryElement(data: triData, primitiveType: .triangleStrip , primitiveCount: vertices.count*2, bytesPerIndex: MemoryLayout<CInt>.size)
    
    return SCNGeometry(sources: [vertexSource,normalSource,/*tcoordSource,*/colorSource], elements: [geometryElement])
}



//var vertices: [Vertex] = [ /* ... vertex data ... */ ]
func createTriangleGeometry(_ vertices:[Vertex], triangles:[CInt])->SCNGeometry{
    let data = Data(bytes: UnsafeRawPointer(vertices), count: vertices.count * MemoryLayout<Vertex>.size)
    
    let vertexSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.vertex,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<GLfloat>.size,
        dataOffset: 0, // position is first member in Vertex
        dataStride: MemoryLayout<Vertex>.size)
    
    let normalSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.normal,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<GLfloat>.size,
        dataOffset: MemoryLayout<Float3>.size, // one Float3 before normal in Vertex
        dataStride: MemoryLayout<Vertex>.size)
    
    //    let tcoordSource = SCNGeometrySource(data: data,
    //        semantic: SCNGeometrySourceSemanticTexcoord,
    //        vectorCount: vertices.count,
    //        floatComponents: true,
    //        componentsPerVector: 2,
    //        bytesPerComponent: sizeof(GLfloat),
    //        dataOffset: 2 * sizeof(Float3), // 2 Float3s before tcoord in Vertex
    //        dataStride: sizeof(Vertex))
    let colorSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.color,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<GLfloat>.size,
        dataOffset: (2 * MemoryLayout<Float3>.size), // 2 Float3s before tcoord in Vertex
        dataStride: MemoryLayout<Vertex>.size)
    
    let triData = Data(bytes: UnsafeRawPointer(triangles), count: MemoryLayout<CInt>.size*triangles.count)
    
    let geometryElement = SCNGeometryElement(data: triData, primitiveType: .triangles , primitiveCount: 1, bytesPerIndex: MemoryLayout<CInt>.size)
    
    return SCNGeometry(sources: [vertexSource,normalSource,/*tcoordSource,*/colorSource], elements: [geometryElement])
}





public func calculateVectorNormal(_ A:SCNVector3, B:SCNVector3, C:SCNVector3)->SCNVector3
{
    let AB = A - B
    let CB = C - B
    var cross = AB.cross(CB)
    
    cross = cross.normalized
    return cross
    
}

public func calculateVectorNormal(_ A:Float3, B:Float3, C:Float3)->Float3
{
    let AB =  Vector3(from:B, to:A)
    let CB = Vector3(from: B, to:C)
    var cross = AB.cross(CB)

    cross = cross.normalized
    return cross.toFloat3()
 
}
