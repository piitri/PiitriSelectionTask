//
//  ParentProfileCell.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 17/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import "ParentProfileCell.h"

@implementation ParentProfileCell
@synthesize parentCellImageView = _parentCellImageView;
@synthesize parentCellMaskImageView = _parentCellMaskImageView;
@synthesize parentNameCellLabel = _parentNameCellLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setParentNameCellLabel:(UILabel *)label{
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    label.textColor = [UIColor colorWithRed:0.04 green:0.11 blue:0.01 alpha:1];
    //label.highlightedTextColor = [UIColor colorWithRed:0.04 green:0.11 blue:0.01 alpha:0.5];
    _parentNameCellLabel=label;
    
}

- (UILabel *)parentNameCellLabel{
    if (!_parentNameCellLabel) {
        _parentNameCellLabel = [[UILabel alloc]init];
    }
    if ([_parentNameCellLabel isHighlighted]) {
        UIColor * newShadow = [UIColor colorWithRed:0.9 green:0.95 blue:0.87 alpha:1];
        _parentNameCellLabel.shadowColor = newShadow;
        CGSize myShadowOffset = CGSizeMake(0, 2);
        [_parentNameCellLabel setShadowOffset:myShadowOffset];
    }
    
    return _parentNameCellLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor * newShadow = [UIColor colorWithRed:0.45 green:0.72 blue:0.24 alpha:1];
    self.parentNameCellLabel.shadowColor = newShadow;
    CGSize myShadowOffset = CGSizeMake(0, 1);
    [self.parentNameCellLabel setShadowOffset:myShadowOffset];
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
