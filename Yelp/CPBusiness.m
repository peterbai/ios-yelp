//
//  CPBusiness.m
//  Yelp
//
//  Created by Peter Bai on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "CPBusiness.h"

@implementation CPBusiness

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
        
        self.name = dictionary[@"name"];
        self.imageURL = dictionary[@"image_url"];
        self.smallImageURL = [self.imageURL stringByReplacingOccurrencesOfString:@"ms.jpg" withString:@"m.jpg"];
        self.largeImageURL = [self.imageURL stringByReplacingOccurrencesOfString:@"ms.jpg" withString:@"o.jpg"];
        
        if ([[dictionary valueForKeyPath:@"location.address"] count] > 0 &&
            [[dictionary valueForKeyPath:@"location.neighborhoods"] count] > 0) {
            NSString *street = [dictionary valueForKeyPath:@"location.address"][0];
            NSString *neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
            NSString *city = [dictionary valueForKeyPath:@"location.city"];
            NSString *state = [dictionary valueForKeyPath:@"location.state_code"];
            NSString *postal = [dictionary valueForKeyPath:@"location.postal_code"];
            self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
            self.fullAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", street, city, state, postal];
        } else {
            NSString *city = [dictionary valueForKeyPath:@"location.city"];
            NSString *state = [dictionary valueForKeyPath:@"location.state_code"];
            self.address = city;
            self.fullAddress = [NSString stringWithFormat:@"%@, %@", city, state];
        }

        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url_large"];
        
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
        
        self.locationLatitude = [[dictionary valueForKeyPath:@"location.coordinate.latitude"] floatValue];
        self.locationLongitude = [[dictionary valueForKeyPath:@"location.coordinate.longitude"] floatValue];
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    
    NSMutableArray *businesses = [NSMutableArray array];

    for (NSDictionary *dictionary in dictionaries) {
        CPBusiness *business = [[CPBusiness alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    
    return businesses;
}

@end
