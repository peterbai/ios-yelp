//
//  ExpandCell.m
//  Yelp
//
//  Created by Peter Bai on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "ExpandCell.h"

@interface ExpandCell ()

@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@end

@implementation ExpandCell

- (void)awakeFromNib {
    // Initialization code
    
    UIImage *expandArrow = [UIImage imageNamed:@"ExpandArrow"];
    
    [self.expandButton setBackgroundImage:expandArrow forState:UIControlStateNormal];
    [self.expandButton setBackgroundImage:expandArrow forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onButtonTapped:(id)sender {
    
}

@end
