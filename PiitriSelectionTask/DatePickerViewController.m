//
//  DatePickerViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 12/08/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController
@synthesize birthdayDatePicker=_birthdayDatePicker;
@synthesize birthdayDatePickerDateStr = _birthdayDatePickerDateStr;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    popoverView.backgroundColor = [UIColor redColor];
    [self.birthdayDatePicker setHidden:NO];
    
    self.birthdayDatePicker.frame = CGRectMake(0, 0, 320, 216);
    
    //[popoverView addSubview:self.datePickerTest];
    //popoverContent.view = popoverView;
    [popoverView addSubview:self.birthdayDatePicker];
    self.view = popoverView;
}

- (void)viewDidUnload
{
    [self setBirthdayDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)birthdayDatePickerChanged:(UIDatePicker *)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.birthdayDatePickerDateStr = [dateFormatter stringFromDate:picker.date];
    
    [self.delegate datePickerViewController:self chosenDateStr:self.birthdayDatePickerDateStr];
    
    
    
    
}

@end
