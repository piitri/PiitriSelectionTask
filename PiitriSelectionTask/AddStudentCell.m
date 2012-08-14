//
//  AddStudentCell.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 12/08/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "AddStudentCell.h"

@implementation AddStudentCell

@synthesize addStudentBackground=_addStudentBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(UIView *)backgroundView{
    UIImage * newImage = [UIImage imageNamed:@"btn-add-student-inactive.png"];
    return [[UIImageView alloc] initWithImage:newImage];
}


/*- (UIImageView *)addStudentBackground{
    if (self.highlighted) {
        UIImageView * imageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-active.png"]];
        return imageBackground;
    }else {
        UIImageView * imageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-inactive.png"]];
        return imageBackground;
    }
    
}*/

/*- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        UIImageView * imageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-inactive.png"]];
        self.selectedBackgroundView = imageBackground;
    }else {
        UIImageView * imageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-inactive.png"]];
        self.backgroundView = imageBackground;
        //self.selectedBackgroundView = imageBackground;
    }
    //UIImage * newImage = [UIImage imageNamed:@"btn-add-student-active.png"];
    //self.backgroundView = [[UIImageView alloc] initWithImage:newImage];
    [super setHighlighted:highlighted animated:animated];
 
}*/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //UIColor * newShadow = selected ? [UIColor colorWithRed:0.9 green:0.95 blue:0.87 alpha:1] : [UIColor colorWithRed:0.45 green:0.72 blue:0.24 alpha:1];
    UIImage * newImage = selected ?[UIImage imageNamed:@"btn-add-student-active.png"]:[UIImage imageNamed:@"btn-add-student-inactive.png"];
    self.backgroundView = [[UIImageView alloc] initWithImage:newImage];
    /*if (!selected) {
        UIImage * newImage = [UIImage imageNamed:@"btn-add-student-inactive.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage:newImage];
    }*/
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
