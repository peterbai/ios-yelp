//
//  MapViewController.h
//  Yelp
//
//  Created by Peter Bai on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

- (void)mapViewController:(MapViewController *)mvc search:(NSString *)query inRegion:(MKCoordinateRegion)region;

@end

@interface MapViewController : UIViewController

@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSDictionary *region;

@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

@end
