//
//  ViewController.swift
//  NSCollectionViewDragDrop
//
//  Created by Harry Ng on 27/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var strings = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var draggingIndexPaths: Set<IndexPath> = []
    var draggingItem: NSCollectionViewItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(forDraggedTypes: [NSPasteboardTypeString])
        
        collectionView.backgroundColors = [NSColor.black]
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func addToTop(_ sender: AnyObject) {
        strings.insert("Top", at: 0)
        
        let indexPaths: Set<IndexPath> = [IndexPath(item: 0, section: 0)]
        collectionView.animator().performBatchUpdates({
            self.collectionView.scroll(NSPoint(x: 0, y: 0))
            self.collectionView.insertItems(at: indexPaths)
            }, completionHandler: { finished in
                self.collectionView.reloadData()
        })
    }

    @IBAction func removeFromTop(_ sender: AnyObject) {
        guard strings.count > 0 else { return }
        
        strings.removeFirst()
        
        let indexPaths: Set<IndexPath> = [IndexPath(item: 0, section: 0)]
        collectionView.animator().performBatchUpdates({
            self.collectionView.animator().deleteItems(at: indexPaths)
            }, completionHandler: { finished in
                self.collectionView.reloadData()
        })
    }
    
    @IBAction func replaceLast(_ sender: AnyObject) {
        guard strings.count > 0 else { return }
        
        strings.removeLast()
        strings.append("Last")
        
        let indexPaths: Set<IndexPath> = [IndexPath(item: strings.count - 1, section: 0)]
        
        collectionView.animator().performBatchUpdates({
            self.collectionView.deleteItems(at: indexPaths)
            self.collectionView.insertItems(at: indexPaths)
            }, completionHandler: { finished in
                self.collectionView.reloadData()
        })
    }
    
    @IBAction func scrollTo(_ sender: AnyObject) {
        let rect = collectionView.frameForItem(at: 2)
        //collectionView.scrollPoint(rect.origin)
        
        let clipView = collectionView.enclosingScrollView!.contentView
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 2
        clipView.animator().setBoundsOrigin(rect.origin)
        NSAnimationContext.endGrouping()
        
        clipView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: "boundsDidChange:", name: NSNotification.Name.NSViewBoundsDidChange, object: clipView)
    }
    
    func boundsDidChange(_ notification: Notification) {
        print("boundsDidChange")
    }
}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return strings.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return collectionView.makeItem(withIdentifier: "MyItem", for: indexPath)
    }
    
}

extension ViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        item.textField?.stringValue = "\(strings[indexPath.item]) \(indexPath.item)"
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        draggingIndexPaths = indexPaths
        
        if let indexPath = draggingIndexPaths.first,
            let item = collectionView.item(at: indexPath) {
            draggingItem = item
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        draggingIndexPaths = []
        draggingItem = nil
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        let pb = NSPasteboardItem()
        pb.setString(strings[indexPath.item], forType: NSPasteboardTypeString)
        return pb
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<IndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        let proposedDropIndexPath = proposedDropIndexPath.pointee
        if let draggingItem = draggingItem,
            let currentIndexPath = collectionView.indexPath(for: draggingItem),
            currentIndexPath != proposedDropIndexPath {
            
            collectionView.animator().moveItem(at: currentIndexPath, to: proposedDropIndexPath)
        }
        
        return .move
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionViewDropOperation) -> Bool {
        for fromIndexPath in draggingIndexPaths {
            let temp = strings.remove(at: fromIndexPath.item)
            strings.insert(temp, at: (indexPath.item <= fromIndexPath.item) ? indexPath.item : (indexPath.item - 1))
            
            //NSAnimationContext.currentContext().duration = 0.5
            collectionView.animator().moveItem(at: fromIndexPath, to: indexPath)
        }
        
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingImageForItemsAt indexPaths: Set<IndexPath>, with event: NSEvent, offset dragImageOffset: NSPointPointer) -> NSImage {
        return NSImage(named: NSImageNameFolder)!
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingImageForItemsAt indexes: IndexSet, with event: NSEvent, offset dragImageOffset: NSPointPointer) -> NSImage {
        return NSImage(named: NSImageNameFolder)!
    }
    
}
