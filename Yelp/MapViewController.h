//
//  MapViewController.h
//  Yelp
//
//  Created by Peter Bai on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CPBusiness.h"

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

- (void)mapViewController:(MapViewController *)mvc search:(NSString *)query withFilters:(NSDictionary *)filters inRegion:(MKCoordinateRegion)region;
- (void)mapViewController:(MapViewController *)mvc setSearchTerm:(NSString *)searchTerm;
- (NSArray *)businessesForMapViewController:(MapViewController *)mvc;
- (NSDictionary *)mapRegionForMapViewController:(MapViewController *)mvc;

@end

@interface MapViewController : UIViewController

@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSDictionary *region;
@property (nonatomic, strong) NSString *searchTerm;

@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

@end
