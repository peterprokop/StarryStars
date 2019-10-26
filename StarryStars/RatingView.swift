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
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float)
}

/**
 Rating bar, fully customisable from Interface builder
*/
@IBDesignable
open class RatingView: UIView {
   
    /// Total number of stars
    @IBInspectable open var starCount: Int = 5
    
    /// Image of unlit star, if nil "starryStars_off" is used
    @IBInspectable open var offImage: UIImage?
    
    /// Image of fully lit star, if nil "starryStars_on" is used
    @IBInspectable open var onImage: UIImage?
    
    /// Image of half-lit star, if nil "starryStars_half" is used
    @IBInspectable open var halfImage: UIImage?
    
    /// Current rating, updates star images after setting
    @IBInspectable open var rating: Float = 0 {
        didSet {
            // If rating is more than starCount simply set it to starCount
            rating = min(Float(starCount), rating)
            
            updateRating()
        }
    }
    
    /// If set to "false" only full stars will be lit
    @IBInspectable open var halfStarsAllowed: Bool = true
    
    /// If set to "false" user will not be able to edit the rating
    @IBInspectable open var editable: Bool = true

    /// Delegate, must confrom to *RatingViewDelegate* protocol
    @objc open weak var delegate: RatingViewDelegate?
    
    var stars: [UIImageView] = []

    override open var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            updateTransform()
        }
    }

    private var shouldUseRightToLeft: Bool {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
            == .rightToLeft
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        customInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        customInit()
    }
    
    func customInit() {
        let bundle = Bundle(for: RatingView.self)

        if offImage == nil {
            offImage = UIImage(named: "starryStars_off", in: bundle, compatibleWith: self.traitCollection)
        }
        if onImage == nil {
            onImage = UIImage(named: "starryStars_on", in: bundle, compatibleWith: self.traitCollection)
        }
        
        if halfImage == nil {
            halfImage = UIImage(named: "starryStars_half", in: bundle, compatibleWith: self.traitCollection)
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

        updateTransform()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        layoutStars()
    }

    private func updateTransform() {
        transform = shouldUseRightToLeft
            ? CGAffineTransform.init(scaleX: -1, y: 1)
            : .identity
    }
    
    private func layoutStars() {
        guard !stars.isEmpty, let offImage = stars.first?.image else {
            return
        }

        let halfWidth = offImage.size.width/2
        let distance = (bounds.size.width - (offImage.size.width * CGFloat(starCount))) / CGFloat(starCount + 1) + halfWidth

        for (index, iv) in stars.enumerated() {
            iv.frame = CGRect(x: 0, y: 0, width: offImage.size.width, height: offImage.size.height)

            iv.center = CGPoint(
                x: CGFloat(index + 1) * distance + halfWidth * CGFloat(index),
                y: self.frame.size.height/2
            )
        }
    }
    
    /**
     Compute and adjust rating when user touches begin/move/end
    */
    func handleTouches(_ touches: Set<UITouch>) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)

        var i = starCount - 1
        while i >= 0 {
            let imageView = stars[i]
            
            let x = touchLocation.x;
            
            if x >= imageView.center.x {
                rating = Float(i) + 1
                return
            } else if x >= imageView.frame.minX && halfStarsAllowed {
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
        guard !stars.isEmpty else {
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
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
        guard let delegate = delegate else { return }
        delegate.ratingView(self, didChangeRating: rating)
    }
}

@objc extension RatingView {
    @objc public enum FillDirection: Int {
        case automatic
        case leftToRight
        case rightToLeft
    }
}
