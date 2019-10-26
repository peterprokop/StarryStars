//
//  ViewController.swift
//
//  Created by Peter Prokop on 23/10/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

import UIKit
import StarryStars

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rvRightToLeft = RatingView()

        rvRightToLeft.frame = view.bounds

        view.addSubview(rvRightToLeft)
        rvRightToLeft.editable = true
        rvRightToLeft.delegate = self

        // RatingView will respect setting this property
        rvRightToLeft.semanticContentAttribute = .forceRightToLeft
    }

}

extension ViewController: RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
        print("ratingView \(ratingView) didChangeRating \(newRating)")
    }

}

