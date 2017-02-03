//
//  TrianglePointerView.swift
//  ChessTimer
//
//  Created by David Crooks on 27/01/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit

@IBDesignable class TrianglePointerView: UIView {
    
    @IBInspectable var color:UIColor = UIColor.black
    
    lazy var triangle:Polygon = {
        
        let rect = self.bounds
        return Polygon(corners: [
            rect.topLeft,
            rect.topRight,
            rect.bottomCenter])
    }()
  
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor);
            triangle.draw(renderer: context)
            context.fill()
        }
    }

}
