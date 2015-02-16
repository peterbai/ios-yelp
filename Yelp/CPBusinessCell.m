//
//  CPBusinessCell.m
//  Yelp
//
//  Created by Peter Bai on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "CPBusinessCell.h"
#import <UIImageView+AFNetworking.h>

@interface CPBusinessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation CPBusinessCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark View methods

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

#pragma mark Custom setters

- (void)setBusiness:(CPBusiness *)business {
    _business = business;
    
    // Configure image and labels
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageURL]];
    self.nameLabel.text = self.business.name;
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", (long)self.business.numReviews];
    self.addressLabel.text = self.business.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    self.categoryLabel.text = self.business.categories;
}

@end
