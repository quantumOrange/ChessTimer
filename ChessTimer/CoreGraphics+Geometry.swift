//
//  CoreGraphics+Geometry.swift
//  ChessTimer
//
//  Created by David Crooks on 27/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation
import CoreGraphics

func +(lhs:CGPoint,rhs:CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs:CGPoint,rhs:CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func *(lhs:CGAffineTransform, rhs:CGAffineTransform) -> CGAffineTransform {
    return lhs.concatenating(rhs)
}

extension CGAffineTransform {
    func aboutPoint(x:CGFloat,y:CGFloat) -> CGAffineTransform {
        let Tplus = CGAffineTransform.init(translationX: x, y: y)
        let Tminus = CGAffineTransform.init(translationX: -x, y: -y)
        return Tplus * self * Tminus
    }
}

extension CGRect {
    
    var bottomRight:CGPoint {
        get {
            return CGPoint(x: origin.x   +  size.width, y: origin.y +  size.height)
        }
        set {
            origin = CGPoint(x: newValue.x - size.width, y: newValue.y - size.height)
        }
    }
    
    var topRight:CGPoint {
        get {
            return CGPoint(x: origin.x   +  width, y: origin.y )
        }
        set {
            origin = CGPoint(x: newValue.x - size.width, y: newValue.y)
        }
    }
    
    var bottomLeft:CGPoint {
        get {
            return CGPoint(x: origin.x  , y: origin.y +  size.height)
        }
        set {
            origin = CGPoint(x: newValue.x, y: newValue.y - size.height)
        }
    }
    
    var topLeft:CGPoint {
        get {
            return origin
        }
        set {
            origin = newValue
        }
    }
    
    var center:CGPoint {
        get {
            return CGPoint(x: origin.x   + 0.5*size.width, y: origin.y +  0.5*size.height)
        }
        set {
            origin = CGPoint(x: newValue.x - 0.5*size.width, y: newValue.y - 0.5*size.height)
        }
    }
    
    var topCenter:CGPoint {
        get {
            return CGPoint(x: origin.x   + 0.5*size.width, y: origin.y)
        }
        set {
            origin = CGPoint(x: newValue.x - 0.5*size.width, y: newValue.y)
        }
    }
    
    var bottomCenter:CGPoint {
        get {
            return CGPoint(x: origin.x   + 0.5*size.width, y: origin.y +  size.height)
        }
        set {
            origin = CGPoint(x: newValue.x - 0.5*size.width, y: newValue.y - size.height)
        }
    }
    var leftCenter:CGPoint {
        get {
            return CGPoint(x: origin.x , y: origin.y +  0.5*size.height)
        }
        set {
            origin = CGPoint(x: newValue.x , y: newValue.y - 0.5*size.height)
        }
    }
    var rightCenter:CGPoint {
        get {
            return CGPoint(x: origin.x   + size.width, y: origin.y +  0.5*size.height)
        }
        set {
            origin = CGPoint(x: newValue.x - size.width, y: newValue.y - 0.5*size.height)
        }
    }
    
}
