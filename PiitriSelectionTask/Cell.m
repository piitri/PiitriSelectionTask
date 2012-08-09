//
//  Cell.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 7/08/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize studentCellImageView = _studentCellImageView;
@synthesize studentCellMaskImageView = _studentCellMaskImageView;
@synthesize studentNameCellLabel = _studentNameCellLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self.studentNameCellLabel setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        CGSize myShadowOffset = CGSizeMake(4, -4);
        //[self.studentNameCellLabel setShadowOffset:myShadowOffset];
        self.studentNameCellLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.studentNameCellLabel.shadowOffset = myShadowOffset;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.studentNameCellLabel setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    CGSize myShadowOffset = CGSizeMake(2, -2);
    [self.studentNameCellLabel setShadowOffset:myShadowOffset];
}

@end
