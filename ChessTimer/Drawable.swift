//
//  File.swift
//  ChessTimer
//
//  Created by David Crooks on 26/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//
//Bassed on Apple example Crustacean playground

import Foundation
import CoreGraphics
import UIKit
let twoPi = CGFloat(M_PI * 2)
let piByTwo = CGFloat(M_PI * 0.5)

protocol Renderer {
    /// Moves the pen to `position` without drawing anything.
    func moveTo(position: CGPoint)
    
    /// Draws a line from the pen's current position to `position`, updating
    /// the pen position.
    func lineTo(position: CGPoint)
    
    /// Draws the fragment of the circle centered at `c` having the given
    /// `radius`, that lies between `startAngle` and `endAngle`, measured in
    /// radians.
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
    
    
    func setFillColor(color:UIColor)
    
    func fill()
    
    
}
struct TestRenderer : Renderer {
    func moveTo(position p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    
    func lineTo(position p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
    
    func setFillColor(color:UIColor){
        print("Set fill with \(color)")
    }
    
    func fill()
    {
        print("fill path")
    }
}

//: An element of a `Diagram`.  Concrete examples follow.
protocol Drawable {
    /// Issues drawing commands to `renderer` to represent `self`.
    func draw(renderer: Renderer)
    //func draw(renderer: Renderer, with color:UIColor)
}

struct Polygon : Drawable {
    func draw(renderer: Renderer) {
        renderer.moveTo(position: corners.last!)
        for p in corners { renderer.lineTo(position: p) }
    }
    var corners: [CGPoint] = []
}

struct Circle : Drawable {
    func draw(renderer: Renderer) {
        renderer.arcAt(center: center, radius: radius, startAngle: 0.0, endAngle: twoPi)
    }
    var center: CGPoint
    var radius: CGFloat
}

struct Wedge : Drawable {
    
    func draw(renderer: Renderer) {
        renderer.moveTo(position: center)
        //renderer.lineTo(CGPoint(x:center.x,y:center.y - radius))
        renderer.arcAt(center: center, radius: radius, startAngle: -piByTwo, endAngle: -piByTwo-angle)
        renderer.lineTo(position: center)
    }
    var center: CGPoint
    var radius: CGFloat
    var angle: CGFloat
    
}

extension CGContext : Renderer {
    func fill() {
        self.fillPath()
    }

    func moveTo(position: CGPoint) {
        move(to:position)
    }
    func lineTo(position: CGPoint) {
        addLine(to:position)
    }
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        let arc = CGMutablePath()

        
        arc.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        addPath(arc)
    }
    
    func setFillColor(color:UIColor){
        self.setFillColor(color.cgColor)
    }
    
    

}
