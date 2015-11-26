//
//  ObjCViewController.m
//  StarryStarsExample
//
//  Created by Peter Prokop on 26/11/15.
//  Copyright © 2015 Peter Prokop. All rights reserved.
//

#import "ObjCViewController.h"
#import "StarryStarsExample-Swift.h"

@interface ObjCViewController()<RatingViewDelegate>

@end

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    RatingView* rv = [[RatingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:rv];
    rv.editable = YES;
    rv.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)ratingView:(RatingView * __nonnull)ratingView didChangeRating:(float)newRating {
    NSLog(@"newRating: %f", newRating);
}


@end
