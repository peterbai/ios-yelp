//
//  CPBusiness.h
//  Yelp
//
//  Created by Peter Bai on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPBusiness : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *smallImageURL;
@property (nonatomic, strong) NSString *largeImageURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *fullAddress;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic) CGFloat distance;
@property (nonatomic) CGFloat locationLatitude;
@property (nonatomic) CGFloat locationLongitude;

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries;

@end
