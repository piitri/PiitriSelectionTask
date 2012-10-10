//
//  ParentProfileCell.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 17/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentProfileCell : UITableViewCell{
    UIImageView * parentCellImageView;
    UIImageView * parentCellMaskImageView;
    UILabel * parentNameCellLabel;
}
@property (nonatomic,strong) IBOutlet UIImageView * parentCellImageView;
@property (nonatomic,strong) IBOutlet UIImageView * parentCellMaskImageView;
@property (nonatomic,strong) IBOutlet UILabel * parentNameCellLabel;



@end
