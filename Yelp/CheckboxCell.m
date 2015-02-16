//
//  CheckboxCell.m
//  Yelp
//
//  Created by Peter Bai on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "CheckboxCell.h"

@interface CheckboxCell ()

@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@end

@implementation CheckboxCell

- (void)awakeFromNib {
    // Initialization code
    
    UIImage *checkBox = [UIImage imageNamed:@"Checkbox"];
    checkBox = [checkBox imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *checkBoxEnabled = [UIImage imageNamed:@"CheckboxEnabled"];
    checkBoxEnabled = [checkBoxEnabled imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.checkBox setBackgroundImage:checkBox forState:UIControlStateNormal];
    [self.checkBox setBackgroundImage:checkBoxEnabled forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkBoxTapped:(id)sender {
    if (self.on == YES) {
        [self setOn:NO];
    } else {
        [self setOn:YES];
    }
    
    [self.delegate checkboxCell:self didUpdateValue:self.on];
}

- (void)setOn:(BOOL)on {
    _on = on;
    self.checkBox.selected = on;
}

@end
