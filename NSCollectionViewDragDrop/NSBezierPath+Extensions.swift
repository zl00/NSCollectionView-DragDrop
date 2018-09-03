//
//  NSBezierPath+Extensions.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 9/3/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

extension NSBezierPath {
    func toCGPath () -> CGPath? {
        if self.elementCount == 0 {
            return nil
        }
        
        let path = CGMutablePath()
        
        var didClosePath = false
        
        for i in 0...self.elementCount-1 {
            var points = [NSPoint](repeating: NSZeroPoint, count: 3)
            
            switch self.element(at: i, associatedPoints: &points) {
            case .moveToBezierPathElement:
                path.move(to: points[0])
//                CGPathMoveToPoint(path, &m, points[0].x, points[0].y)
                
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
//                CGPathAddLineToPoint(path, &m, points[0].x, points[0].y)
                
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
//                CGPathAddCurveToPoint(path, &m, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
                
            case .closePathBezierPathElement:
                path.closeSubpath()
                didClosePath = true
            }
        }
        
        if !didClosePath {
            path.closeSubpath()
        }
        
        return path.copy()
    }
}
