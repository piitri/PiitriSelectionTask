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
        /*[self.studentNameCellLabel setShadowColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        CGSize myShadowOffset = CGSizeMake(4, 8);
        [self.studentNameCellLabel setShadowOffset:myShadowOffset];
        self.studentNameCellLabel.shadowColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        self.studentNameCellLabel.shadowOffset = myShadowOffset;*/
    }
    
    return self;
}

- (void)setStudentNameCellLabel:(UILabel *)label{
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    label.textColor = [UIColor colorWithRed:0.04 green:0.11 blue:0.01 alpha:1];
    _studentNameCellLabel=label;
    
}

/*- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor * newShadow = highlighted ? [UIColor colorWithRed:1 green:0 blue:0 alpha:1] : [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    self.studentNameCellLabel.shadowColor = newShadow;
    CGSize myShadowOffset = CGSizeMake(4, 8);
    [self.studentNameCellLabel setShadowOffset:myShadowOffset];
    [super setHighlighted:highlighted animated:animated];
}*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor * newShadow = selected ? [UIColor colorWithRed:0.9 green:0.95 blue:0.87 alpha:1] : [UIColor colorWithRed:45 green:72 blue:24 alpha:1];
    self.studentNameCellLabel.shadowColor = newShadow;
    CGSize myShadowOffset = CGSizeMake(0, 1);
    [self.studentNameCellLabel setShadowOffset:myShadowOffset];
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    /*[self.studentNameCellLabel setShadowColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
    CGSize myShadowOffset = CGSizeMake(2, -2);
    [self.studentNameCellLabel setShadowOffset:myShadowOffset];*/
}

@end
