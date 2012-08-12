//
//  ParentPortalViewController.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface ParentPortalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *parentFullName;
@property (strong, nonatomic) IBOutlet UILabel *parentLocation;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *buyCoinsButton;
@property (strong, nonatomic) IBOutlet UILabel *parentEmail;
@property (strong, nonatomic) IBOutlet UILabel *parentBirthday;
@property (strong, nonatomic) IBOutlet UIImageView *parentProfilePicture;
@property (strong, nonatomic) IBOutlet UITextView *cajaTextoParentPortal;

//Table View Variables
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

//Views
@property (strong, nonatomic) IBOutlet UIView *studentForm;
@property (strong, nonatomic) IBOutlet UIView *addStudentView;
@property (strong, nonatomic) IBOutlet UIView *viewParentPortal;

//Student Form Variables
- (IBAction)cancelStudentInfo:(id)sender;
- (IBAction)saveStudentInfo:(id)sender;
- (IBAction)takePhotoAction:(id)sender;
- (IBAction)birthdayDateChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveStudentInfoButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UILabel *uploadPictureLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageDimensionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *studentImageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthField;
@property (strong, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *currentSchoolLabel;
@property (strong, nonatomic) IBOutlet UITextField *currentSchoolTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *studentFormActivityIndicator;



- (IBAction)disconnectFromFB:(id)sender;
- (IBAction)backButton:(id)sender;
- (void)useDatosLogin:(id)resultado withToken:(NSString *) accessToken;

@end
