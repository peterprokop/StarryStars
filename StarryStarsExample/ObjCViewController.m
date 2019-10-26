//
//  ObjCViewController.m
//  StarryStarsExample
//
//  Created by Peter Prokop on 26/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

#import "ObjCViewController.h"
#import "StarryStarsExample-Swift.h"
#import <StarryStars/StarryStars-Swift.h>

@interface ObjCViewController()<RatingViewDelegate>

@end

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RatingView* rv = [[RatingView alloc] init];
    rv.frame = CGRectMake(
                          self.view.bounds.origin.x,
                          self.view.bounds.origin.y,
                          self.view.bounds.size.width,
                          self.view.bounds.size.height/2
                          );

    [self.view addSubview:rv];
    rv.editable = YES;
    rv.delegate = self;

    RatingView* rvRightToLeft = [[RatingView alloc] init];

    rvRightToLeft.frame = CGRectMake(
                          self.view.bounds.origin.x,
                          self.view.bounds.origin.y + self.view.bounds.size.height/2,
                          self.view.bounds.size.width,
                          self.view.bounds.size.height/2
                          );

    [self.view addSubview:rvRightToLeft];
    rvRightToLeft.editable = YES;
    rvRightToLeft.delegate = self;

    // RatingView will respect setting this property
    rvRightToLeft.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)ratingView:(RatingView * __nonnull)ratingView didChangeRating:(float)newRating {
    NSLog(@"ratingView %@ didChangeRating: %.1f", ratingView, newRating);
}


@end
