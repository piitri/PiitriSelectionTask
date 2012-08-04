//
//  ParentPortalViewController.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ParentPortalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
}
@property (strong, nonatomic) IBOutlet UILabel *parentFullName;
@property (strong, nonatomic) IBOutlet UILabel *parentSmallName;
@property (strong, nonatomic) IBOutlet UILabel *parentLocation;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *buyCoinsButton;
@property (strong, nonatomic) IBOutlet UILabel *parentEmail;
@property (strong, nonatomic) IBOutlet UILabel *parentBirthday;
@property (strong, nonatomic) IBOutlet UIImageView *parentProfilePicture;
@property (strong, nonatomic) IBOutlet UIImageView *smallParentProfilePicture;
@property (strong, nonatomic) IBOutlet UITextView *cajaTextoParentPortal;
@property (strong, nonatomic) IBOutlet UIButton *accountsButton;
@property (strong, nonatomic) IBOutlet UIButton *addNewStudentButton;
@property (strong, nonatomic) IBOutlet UIButton *myLessonsButton;
@property (strong, nonatomic) IBOutlet UIButton *storeButton;


//Table View Variables
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *studentForm;
@property (strong, nonatomic) IBOutlet UIView *viewParentPortal;


- (IBAction)disconnectFromFB:(id)sender;
- (IBAction)backButton:(id)sender;
- (void)useDatosLogin:(id)resultado withToken:(NSString *) accessToken;

@end
