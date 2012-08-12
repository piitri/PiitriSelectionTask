//
//  MainSideMenuItemCell.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 11/08/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "MainSideMenuItemCell.h"

@implementation MainSideMenuItemCell

@synthesize mainItemCellLabel = _mainItemCellLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    
    return self;
}

- (void)setMainItemCellLabel:(UILabel *)label{
    label.font = [UIFont fontWithName:@"MetaPlus" size:20];
    label.textColor = [UIColor whiteColor];
    label.highlightedTextColor = [UIColor colorWithRed:0.04 green:0.11 blue:0.01 alpha:0.5];
    _mainItemCellLabel=label;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor * newShadow = selected ? [UIColor colorWithRed:0.9 green:0.95 blue:0.87 alpha:1] : [UIColor colorWithRed:45 green:72 blue:24 alpha:1];
    self.mainItemCellLabel.shadowColor = newShadow;
    CGSize myShadowOffset = CGSizeMake(0, 1);
    [self.mainItemCellLabel setShadowOffset:myShadowOffset];
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
