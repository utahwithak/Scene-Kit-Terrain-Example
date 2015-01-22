//
//  Vector3.swift
//  Settlers
//
//  Created by Carl Wieland on 12/22/14.
//  Copyright (c) 2014 Carl Wieland. All rights reserved.
//

import Foundation
import SceneKit

typealias Vector3 = SCNVector3

public extension SCNVector3{
    static var up:SCNVector3{
        return Vector3(x: 0, y: 1, z: 0)
    }
    static var right:SCNVector3{
        return Vector3(x: 1, y: 0, z: 0)
    }
    static var left:SCNVector3{
        return Vector3(x: -1, y: 0, z: 0)
    }
    static var down:SCNVector3{
        return Vector3(x: 0, y: -1, z: 0)
    }
    static var forward:SCNVector3{
        return Vector3(x: 0, y: 0, z: 1)
    }
    static var back:SCNVector3{
        return Vector3(x: 0, y: 0, z: -1)
    }
    
    internal init(from:Float3, to:Float3){
        self.x = CGFloat(to.x - from.x)
        self.y = CGFloat(to.y - from.y)
        self.z = CGFloat(to.z - from.z)
    }
    
    init(from point:Float3){
        self.x = CGFloat(point.x)
        self.y = CGFloat(point.y)
        self.z = CGFloat(point.z)
    }
    
    internal func toFloat3()->Float3{
        return Float3(x: GLfloat(self.x), y: GLfloat(self.y), z: GLfloat(self.z))
    }
    
    func cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
    var length:Double{
        let sqrX = self.x * self.x
        let sqrY = self.y * self.y
        let sqrZ = self.z * self.z
        
        return sqrt(Double(sqrX + sqrY + sqrZ))
    }
    var point:NSPoint{
        return NSPoint(x: x, y: y)
    }
    var normalized:SCNVector3{
        let len = CGFloat(length)
        
        if len != 0{
            return Vector3(x: self.x/len, y: self.y/len, z: self.z/len)
        }
        return self
    }
    
    var magnitude:CGFloat{
        return sqrt(Vector3.dot(self, b: self))
    }
    
    func copy()->SCNVector3{
        return SCNVector3(x: x, y: y, z: z)
    }
    
    static func angle(from:SCNVector3 , to:SCNVector3)->CGFloat
    {
        let clamped = clamp ( dot(from.normalized, b: to.normalized), -1, 1)
        return acos(clamped) * CGFloat(180.0 / M_PI);
    }
    
    static func dot(a:SCNVector3, b:SCNVector3)->CGFloat{
        return (a.x*b.x) + (a.y*b.y) + (a.z*b.z)
    }
    static func moveTowards ( current:SCNVector3,  target:SCNVector3,  maxDistanceDelta:CGFloat)->SCNVector3
    {
        let a = target - current;
        let magnitude = a.magnitude;
        if (magnitude <= maxDistanceDelta || magnitude == 0)
        {
            return target;
        }
        return current + (a / magnitude * maxDistanceDelta);
    }

}
extension SCNVector3:DebugPrintable{
    public var debugDescription:String{
        return "[x:\(x) y:\(y) z:\(z)]"
    }
}


func - (left:Vector3, right:Vector3)->Vector3{
    return Vector3(x: left.x-right.x, y: left.y-right.y, z: left.z-right.z)
}

func * (left:Vector3, right:CGFloat)->Vector3{
    return Vector3(x: left.x * right, y: left.y * right, z: left.z * right)
}

func + (left:Vector3, right:Vector3)->Vector3{
    return Vector3(x: left.x+right.x, y: left.y+right.y, z: left.z+right.z)
}

func / (a:Vector3, d:CGFloat)->Vector3{
    return Vector3 (x:a.x / d,y: a.y / d,z: a.z / d);
}


