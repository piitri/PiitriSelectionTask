//
//  DatePickerViewController.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 12/08/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate
@optional
- (void) datePickerViewController:(DatePickerViewController *)sender chosenDateStr:(NSString *) dateStr; 

@end

@interface DatePickerViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIDatePicker *birthdayDatePicker;
@property (nonatomic, strong) NSString * birthdayDatePickerDateStr;
@property (nonatomic, weak) id <DatePickerViewControllerDelegate> delegate;

@end
