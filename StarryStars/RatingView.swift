//
//  RatingView.swift
//
//  Created by Peter Prokop on 18/10/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import UIKit

@objc public protocol RatingViewDelegate {
    /**
     Called when user's touch ends
     
     - parameter ratingView: Rating view, which calls this method
     - parameter didChangeRating newRating: New rating
    */
    func ratingView(ratingView: RatingView, didChangeRating newRating: Float)
}

/**
 Rating bar, fully customisable from Interface builder
*/
@IBDesignable
public class RatingView: UIView {
   
    /// Total number of stars
    @IBInspectable public var starCount: Int = 5
    
    /// Image of unlit star, if nil "starryStars_off" is used
    @IBInspectable public var offImage: UIImage?
    
    /// Image of fully lit star, if nil "starryStars_on" is used
    @IBInspectable public var onImage: UIImage?
    
    /// Image of half-lit star, if nil "starryStars_half" is used
    @IBInspectable public var halfImage: UIImage?
    
    /// Current rating, updates star images after setting
    @IBInspectable public var rating: Float = Float(0) {
        didSet {
            // If rating is more than starCount simply set it to starCount
            rating = min(Float(starCount), rating)
            
            updateRating()
        }
    }
    
    /// If set to "false" only full stars will be lit
    @IBInspectable public var halfStarsAllowed: Bool = true
    
    /// If set to "false" user will not be able to edit the rating
    @IBInspectable public var editable: Bool = true
    
    
    /// Delegate, must confrom to *RatingViewDelegate* protocol
    public weak var delegate: RatingViewDelegate?
    
    var stars = [UIImageView]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        customInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        customInit()
    }
    
    func customInit() {
        let bundle = NSBundle(forClass: RatingView.self)

        if offImage == nil {
            offImage = UIImage(named: "starryStars_off", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        }
        if onImage == nil {
            onImage = UIImage(named: "starryStars_on", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        }
        
        if halfImage == nil {
            halfImage = UIImage(named: "starryStars_half", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        }
        
        guard let offImage = offImage else {
            assert(false, "offImage is not set")
            return
        }
        
        var i = 1
        while i <= starCount {
            let iv = UIImageView(image: offImage)
            addSubview(iv)
            stars.append(iv)
            i += 1
        }
        
        layoutStars()
        updateRating()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layoutStars()
    }
    
    func layoutStars() {
        if stars.count != 0,
            let offImage = stars.first?.image {
                let halfWidth = offImage.size.width/2
                let distance = (bounds.size.width - (offImage.size.width * CGFloat(starCount))) / CGFloat(starCount + 1) + halfWidth
                
                var i = 1
                for iv in stars {
                    iv.frame = CGRectMake(0, 0, offImage.size.width, offImage.size.height)
                    
                    iv.center = CGPointMake(CGFloat(i) * distance + halfWidth * CGFloat(i - 1),
                        self.frame.size.height/2)
                    i += 1
                }
        }
    }
    
    /**
     Compute and adjust rating when user touches begin/move/end
    */
    func handleTouches(touches: Set<UITouch>) {
        let touch = touches.first!
        let touchLocation = touch.locationInView(self)
        
        var i = starCount - 1
        while i >= 0 {
            let imageView = stars[i]
            
            let x = touchLocation.x;
            
            if x >= imageView.center.x {
                rating = Float(i) + 1
                return
            } else if x >= CGRectGetMinX(imageView.frame) && halfStarsAllowed {
                rating = Float(i) + 0.5
                return
            }
            i -= 1
        }
        
        
        rating = 0
    }

    /**
     Adjust images on image views to represent new rating
     */
    func updateRating() {
        // To avoid crash when using IB
        if stars.count == 0 {
            return
        }
        
        // Set every full star
        var i = 1
        while i <= Int(rating) {
            let star = stars[i-1]
            star.image = onImage
            i += 1
        }
        
        if i > starCount {
            return
        }
        
        // Now add a half star
        if rating - Float(i) + 1 >= 0.5 {
            let star = stars[i-1]
            star.image = halfImage
            i += 1
        }
        
        while i <= starCount {
            let star = stars[i-1]
            star.image = offImage
            i += 1
        }
    }
}

// MARK: Override UIResponder methods

extension RatingView {
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
        guard let delegate = delegate else { return }
        delegate.ratingView(self, didChangeRating: rating)
    }
}