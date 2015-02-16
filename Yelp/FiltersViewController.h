//
//  FiltersViewController.h
//  Yelp
//
//  Created by Peter Bai on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FilterSection) {
    FilterSectionDeals = 0,
    FilterSectionDistance = 1,
    FilterSectionSort = 2,
    FilterSectionCategories = 3
};

typedef NS_ENUM(NSInteger, SortMethod) {
    SortMethodBestMatch = 0,
    SortMethodDistance = 1,
    SortMethodHighestRated = 2
};

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end