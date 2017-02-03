//
//  ClockFace.swift
//  ChessTimer
//
//  Created by David Crooks on 26/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct ClockFace : Drawable {
    
    init(center:CGPoint, radius: CGFloat, angle:CGFloat) {
        circle = Circle(center:center,radius:radius)
        remainingTimeWedge = Wedge(center:center, radius:radius, angle:angle)
    }
    
    var faceColor = UIColor.black
    var timeColor = UIColor.orange
    var circle:Circle
    
    var remainingTimeWedge:Wedge
    

    func draw(renderer:Renderer) {
        
        renderer.setFillColor(color: faceColor)
        circle.draw(renderer: renderer)
        renderer.fill()

        renderer.setFillColor(color: timeColor)
        remainingTimeWedge.draw(renderer: renderer)
        renderer.fill()
        
    }
}



