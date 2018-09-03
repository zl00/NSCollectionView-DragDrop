//
//  MyView.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 2/3/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

@IBDesignable class MyView: NSView {
    
    var leftArrowLayer: CAShapeLayer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {
        wantsLayer = true
        
        leftArrowLayer = createArrow()
        leftArrowLayer.opacity = 1
        layer?.addSublayer(leftArrowLayer)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        layer?.backgroundColor = NSColor.yellow.cgColor
        
        leftArrowLayer.position = NSPoint(x: 30, y: bounds.height / 2)
    }
    
    override func prepareForInterfaceBuilder() {
        layer?.backgroundColor = NSColor.red.cgColor
    }
    
    func createArrow() -> CAShapeLayer {
        let rect = CGRect(x: 0, y: 0, width: 3, height: 10)
        
        let leftArrow = NSBezierPath()
        leftArrow.move(to: CGPoint(x: 0, y: 0))
        leftArrow.line(to: CGPoint(x: rect.width, y: rect.height / 2))
        leftArrow.line(to: CGPoint(x: 0, y: rect.height))
        
        let shape = CAShapeLayer()
        shape.strokeColor = NSColor.blue.cgColor
        shape.lineWidth = 2
        shape.path = leftArrow.toCGPath()
        shape.bounds = rect
        
        return shape
    }
    
}
