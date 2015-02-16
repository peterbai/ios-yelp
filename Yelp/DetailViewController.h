//
//  DetailViewController.h
//  Yelp
//
//  Created by Peter Bai on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBusiness.h"
#import <FXBlurView.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) CPBusiness *business;

@end
