//
//  RatingView.swift
//
//  Created by Peter Prokop on 18/10/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import UIKit

protocol RatingViewDelegate {
    func ratingView(ratingView: RatingView, didChangeRating newRating: Float)
}

@IBDesignable
public class RatingView: UIView {
   
    @IBInspectable var starCount: Int = 5
    @IBInspectable var offImage: UIImage?
    @IBInspectable var onImage: UIImage?
    @IBInspectable var halfImage: UIImage?
    @IBInspectable var rating: Float = Float(0) {
        didSet {
            // Check if rating is valid
            rating = min(Float(starCount), rating)
            
            updateRating()
        }
    }
    @IBInspectable var halfStarsAllowed: Bool = true
    @IBInspectable var editable: Bool = true
    @IBInspectable var delegate: RatingViewDelegate?
    
    var stars = [UIImageView]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        for var i = 1; i <= starCount; i++ {
            let iv = UIImageView(image: offImage)
            addSubview(iv)
            stars.append(iv)

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
                    i++
                }
        }
    }
    
    func handleTouches(touches: Set<UITouch>) {
        let touch = touches.first!
        let touchLocation = touch.locationInView(self)
        
        for var i = starCount - 1; i >= 0; i-- {
            let imageView = stars[i]
            
            let x = touchLocation.x;
            
            if x >= imageView.center.x {
                rating = Float(i) + 1
                return
            } else if x >= CGRectGetMinX(imageView.frame) && halfStarsAllowed {
                rating = Float(i) + 0.5
                return
            }
        }
        
        rating = 0
    }

    func updateRating() {
        // To avoid crash when using IB
        if stars.count == 0 {
            return
        }
        
        // Set every full star
        var i = 1
        for ; i <= Int(rating); i++ {
            let star = stars[i-1]
            star.image = onImage
        }
        
        if i > starCount {
            return
        }
        
        // Now add a half star
        if rating - Float(i) + 1 >= 0.5 {
            let star = stars[i-1]
            star.image = halfImage
        }
        i++
        
        for ; i <= starCount; i++ {
            let star = stars[i-1]
            star.image = offImage
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
        guard let delegate = delegate else { return }
        delegate.ratingView(self, didChangeRating: rating)
    }
}