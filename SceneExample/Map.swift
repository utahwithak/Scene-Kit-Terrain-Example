//
//  Map.swift
//  Settlers
//
//  Created by Carl Wieland on 1/6/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import CoreData

public enum MapDir:Int{
    case left = 0
    case downLeft = 1
    case downRight = 2
    case right = 3
    case upRight = 4
    case upLeft = 5
    
    
    public var reverse:MapDir{
        return MapDir(rawValue: (self.rawValue + 3) % 6)!
    }
}

@objc(Map)
open class Map: NSObject {
    
    open var width: Int = 0
    open var height: Int = 0
    
    var nodes = [MapNode]()
    
    func indexOf(_ x:Int, _ y:Int)->Int{
        return (y * Int(width)) + x
    }
    
    func translateIndex(_ index:Int)->(x:Int, y:Int){
        let y = index / Int(self.width);
        let x = index - (y * Int(height));
        return (x,y)
    }

    func negate(_ val:UInt64)->Int{
        return (val == 0) ? 1 : 0
    }
    
    func moveIndex(_ index:Int, dir:MapDir)->(x:Int, y:Int){
        let translated = translateIndex(index)
        return movePoint(x: translated.x, y: translated.y, dir: dir)
    }
    
    
  
    /*
    /*
          A_____ B____ X
         /\    /\    /
        /  \  /  \  /
     C /____\/_D__\/ E
       \    /\    /
        \  /  \  /
      Y  \/_F__\/ G
    
    D -> C is Left
    D -> F is Down Left
    D -> G is Down Right
    D -> E is Right
    D -> B is UpRight
    D -> A is Up Left
    
    */
*/
    func movePoint(x x_in:Int,y y_in:Int, dir:MapDir)->(x:Int, y:Int){
        var x = UInt64(x_in)
        var y = UInt64(y_in)

        switch(dir){
        case .upLeft:fallthrough
        case .left:
            if (x == 0){
                x = UInt64(width - 1);
            }
            else{
                x = x - 1
            }
        case .downRight:fallthrough
        case .right:
            if x_in == (width - 1){
                x =  0
            }
            else{
                x = x + 1
            }
        default:
            x = UInt64(x_in)
        }
        
        switch (dir){
        case .downLeft: fallthrough
        case .downRight:
            if y_in == 0{
                y = UInt64(height - 1);
            }
            else{
                y = (y - 1);
            }
        case .upRight: fallthrough
        case .upLeft:
            if y_in == (height - 1){
                y =  0;
            }
            else{
                y = y + 1;
            }
            
        default:
            y = UInt64(y_in);
        }

        return (Int(x),Int(y))
  
    }
    
    
}


