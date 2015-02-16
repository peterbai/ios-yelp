//
//  SwitchCell.m
//  Yelp
//
//  Created by Peter Bai on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"
#import <SevenSwitch.h>

@interface SwitchCell ()

@property (weak, nonatomic) IBOutlet SevenSwitch *toggleSwitch;
- (IBAction)switchValueChanged:(id)sender;


@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.toggleSwitch.onTintColor = [UIColor colorWithRed:25.0/255
                                                   green:154.0/255
                                                    blue:234.0/255
                                                   alpha:1.00];
    self.toggleSwitch.thumbImage = [UIImage imageNamed:@"SwitchThumb"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}

- (void)toggleOn {
    if (self.on) {
        [self setOn:NO animated:YES];

    } else {
        [self setOn:YES animated:YES];
    }
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}


@end
