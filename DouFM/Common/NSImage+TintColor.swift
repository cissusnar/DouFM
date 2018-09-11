import Cocoa

extension NSImage {
    
    /*
     let tintColor = NSColor(red: 1.0, green: 0.08, blue: 0.50, alpha: 1.0)
     let image = NSImage(named: "NAME").imageWithTintColor(tintColor)
     imageView.image = image
     */
	func imageWithTintColor(tintColor: NSColor) -> NSImage {
        guard !self.isTemplate else { return self }
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        tintColor.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
	}
}
