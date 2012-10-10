//
//  ViewController.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LoginViewController : UIViewController
//View Objects
@property (strong, nonatomic) IBOutlet UILabel *textCreateAccount;
@property (strong, nonatomic) IBOutlet UITextView *textWelcome;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *loginFBButton;

//View Actions
- (IBAction)connectWithFB:(id)sender;

@end
