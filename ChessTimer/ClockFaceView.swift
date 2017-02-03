//
//  ClockFaceView.swift
//  ChessTimer
//
//  Created by David Crooks on 26/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit

@IBDesignable class ClockFaceView: UIView {
    var clockFace:ClockFace = ClockFace(center:CGPoint(),radius:0.0,angle:0.0) {
        didSet {
            
            clockFace.faceColor = faceColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var faceColor:UIColor = UIColor.black { didSet {
            clockFace.faceColor = faceColor
            setNeedsDisplay()
        }
    }
    
    
    var isActive = false

    override func draw(_ rect: CGRect) {
        let hue:CGFloat = 240.0/360.0
        let brightness:CGFloat = 0.9
    clockFace.timeColor = isActive ? UIColor(hue: hue, saturation: 0.5, brightness: brightness, alpha: 1.0) : UIColor(hue: hue, saturation: 0.25, brightness: brightness, alpha: 1.0)
        
        if let context = UIGraphicsGetCurrentContext() {
            clockFace.draw(renderer: context)
        }
    }
}
