//
//  MyItem.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 27/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class MyItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent] {
        // Image itemRootView.
        let itemRootView = self.view
        let itemBounds = itemRootView.bounds
        let bitmap = itemRootView.bitmapImageRepForCachingDisplay(in: itemBounds)!
        let bitmapData = bitmap.bitmapData
        if bitmapData != nil {
            bzero(bitmapData, bitmap.bytesPerRow * bitmap.pixelsHigh)
        }
        
        /*
        -cacheDisplayInRect:toBitmapImageRep: won't capture the "SlideCarrier"
        image, since it's rendered via the layer contents property.  Work around
        that by drawing the image into the bitmap ourselves, using a bitmap
        graphics context.
        */
        // Work around SlideCarrierView layer contents not being rendered to bitmap.
        let slideCarrierImage = NSImage(named: NSImageNameFolder)
        NSGraphicsContext.saveGraphicsState()
        let oldContext = NSGraphicsContext.current()
        NSGraphicsContext.setCurrent(NSGraphicsContext(bitmapImageRep: bitmap))
        slideCarrierImage?.draw(in: itemBounds, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        NSGraphicsContext.setCurrent(oldContext)
        NSGraphicsContext.restoreGraphicsState()
        
        /*
        Invoke -cacheDisplayInRect:toBitmapImageRep: to render the rest of the
        itemRootView subtree into the bitmap.
        */
        itemRootView.cacheDisplay(in: itemBounds, to: bitmap)
        let image = NSImage(size: bitmap.size)
        image.addRepresentation(bitmap)
        
        let component = NSDraggingImageComponent(key: NSDraggingImageComponentIconKey)
        component.frame = itemBounds
        component.contents = image
        
        return [component]
    }
    
}
