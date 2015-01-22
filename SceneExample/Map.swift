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
    case Left = 0
    case DownLeft = 1
    case DownRight = 2
    case Right = 3
    case UpRight = 4
    case UpLeft = 5
    
    
    public var reverse:MapDir{
        return MapDir(rawValue: (self.rawValue + 3) % 6)!
    }
}

@objc(Map)
public class Map: NSObject {
    
    public var width: Int = 0
    public var height: Int = 0
    
    var nodes = [MapNode]()
    
    func indexOf(#x:Int,y:Int)->Int{
        return (y * Int(width)) + x
    }
    
    func translateIndex(index:Int)->(x:Int, y:Int){
        let y = index / Int(self.width);
        let x = index - (y * Int(height));
        return (x,y)
    }

    func negate(val:UInt64)->Int{
        return (val == 0) ? 1 : 0
    }
    
    func moveIndex(index:Int, dir:MapDir)->(x:Int, y:Int){
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
        case .UpLeft:fallthrough
        case .Left:
            if (x == 0){
                x = UInt64(width - 1);
            }
            else{
                x = x - 1
            }
        case .DownRight:fallthrough
        case .Right:
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
        case .DownLeft: fallthrough
        case .DownRight:
            if y_in == 0{
                y = UInt64(height - 1);
            }
            else{
                y = (y - 1);
            }
        case .UpRight: fallthrough
        case .UpLeft:
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


