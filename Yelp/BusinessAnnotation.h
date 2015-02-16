//
//  BusinessAnnotation.h
//  Yelp
//
//  Created by Peter Bai on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CPBusiness.h"

@interface BusinessAnnotation : MKPointAnnotation

@property (nonatomic, strong) CPBusiness *business;

@end
