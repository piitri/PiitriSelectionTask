//
//  Cell.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 7/08/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentCell : UITableViewCell{
    UIImageView * studentCellImageView;
    UIImageView * studentCellMaskImageView;
    UILabel * studentNameCellLabel;
}
@property (nonatomic,strong) IBOutlet UIImageView * studentCellImageView;
@property (nonatomic,strong) IBOutlet UIImageView * studentCellMaskImageView;
@property (nonatomic,strong) IBOutlet UILabel * studentNameCellLabel;

@end
