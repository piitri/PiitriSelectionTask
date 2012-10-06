//
//  ParentPortalViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "ParentPortalViewController.h"
#import "ParentModel.h"
#import "Facebook+Singleton.h"
#import "ParentProfileCell.h"
#import "StudentCell.h"
#import "MainSideMenuItemCell.h"
#import "AddStudentCell.h"
#import "DatePickerViewController.h"
#import "PhotoPickerViewController.h"

@interface ParentPortalViewController () <DatePickerViewControllerDelegate, PhotoPickerViewControllerDelegate>{
    NSUserDefaults * defaults;
    //To erase NSMutableArray * sons;
    NSString * studentImageUrlStr;
    UIImage * tempStudentImage;
    UIImagePickerController *imagePickerController;
    NSIndexPath * indexPathDeleteStudent;
    BOOL cameraselected;
    BOOL deleteStudent;
}

//instance variable to recieve the response of the API Call
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, strong) ParentModel * parentUserModel;


@end

@implementation ParentPortalViewController

@synthesize receivedData = _receivedData;
@synthesize parentUserModel = _parentUserModel;

#pragma mark - Parent Portal View Objects
@synthesize parentFullName = _parentFullName;
@synthesize parentLocation = _parentLocation;
@synthesize twitterButton = _twitterButton;
@synthesize facebookButton = _facebookButton;
@synthesize googlePlusButton = _googlePlusButton;
@synthesize editProfileButton = _editProfileButton;
@synthesize buyCoinsButton = _buyCoinsButton;
@synthesize parentProfilePicture = _parentProfilePicture;

#pragma mark - Vars for TableView
@synthesize tableView = _tableView;

#pragma mark - Views
@synthesize studentForm = _studentForm;
@synthesize addStudentView = _addStudentView;
@synthesize viewParentPortal = _viewParentPortal;

#pragma mark - Student Form Variables
@synthesize saveStudentInfoButton = _saveStudentInfoButton;
@synthesize takePhotoButton = _takePhotoButton;
@synthesize uploadPictureLabel = _uploadPictureLabel;
@synthesize imageDimensionLabel = _imageDimensionLabel;
@synthesize studentImageView = _studentImageView;
@synthesize studentMaskImageView = _studentMaskImageView;
@synthesize genderSegmentedControl = _genderSegmentedControl;
@synthesize firstNameLabel = _firstNameLabel;
@synthesize firstNameTextField = _firstNameTextField;
@synthesize lastNameLabel = _lastNameLabel;
@synthesize lastNameTextField = _lastNameTextField;
@synthesize dateOfBirthLabel = _dateOfBirthLabel;
@synthesize dateOfBirthField = _dateOfBirthField;
@synthesize currentSchoolLabel = _currentSchoolLabel;
@synthesize currentSchoolTextField = _currentSchoolTextField;
@synthesize studentFormActivityIndicator = _studentFormActivityIndicator;
@synthesize popoverControllerBirthday=_popoverControllerBirthday;

#pragma mark - 

- (ParentModel *) parentUserModel
{
    if (!_parentUserModel) {
        _parentUserModel = [[ParentModel alloc] init];
    }
    return _parentUserModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Parent Info Customization
    self.parentFullName.font = [UIFont fontWithName:@"MetaPlus" size:30];
    self.parentLocation.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    
    //TableView Customization
    self.tableView.backgroundColor = [UIColor clearColor];
    //To know if Camera or Photo Gallery was selected
    cameraselected = NO;
    //To Make the Alert appear when a Student is to be removed
    deleteStudent = NO;
    indexPathDeleteStudent = nil;
    
    //Student Form Design

    self.takePhotoButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"btn-camera-icon-inactive.png"]];
    [self.studentMaskImageView setHidden:YES];
    [self.studentImageView setHidden:YES];
    self.uploadPictureLabel.font = [UIFont fontWithName:@"MetaPlus" size:18];
    self.imageDimensionLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12];
    self.firstNameLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.lastNameLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.dateOfBirthLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.currentSchoolLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.editProfileButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    self.buyCoinsButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    CGRect firstFrameRect = self.firstNameTextField.frame;
    firstFrameRect.size.height = 60;
    self.firstNameTextField.frame = firstFrameRect;
    
    CGRect lastFrameRect = self.lastNameTextField.frame;
    lastFrameRect.size.height = 60;
    self.lastNameTextField.frame = lastFrameRect;
    
    CGRect birthFrameRect = self.dateOfBirthField.frame;
    birthFrameRect.size.height = 60;
    self.dateOfBirthField.frame = birthFrameRect;
    
    CGRect schoolFrameRect = self.currentSchoolTextField.frame;
    schoolFrameRect.size.height = 60;
    self.currentSchoolTextField.frame = schoolFrameRect;
    
    UIColor *backgroundAddStudent = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light-box-black.png"]];
    self.addStudentView.backgroundColor = backgroundAddStudent;
    UIColor *backgroundStudentForm = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"student-form.png"]];
   self.studentForm.backgroundColor = backgroundStudentForm;
    
    //Segmented Control customization
    
    //Image between two unselected segments.
    [self.genderSegmentedControl setDividerImage:[UIImage imageNamed:@"gender-inactive-segmented.png"] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Image between segment selected on the left and unselected on the right.
    [self.genderSegmentedControl setDividerImage:[UIImage imageNamed:@"gender-boy-active-segmented.png"] forLeftSegmentState:UIControlStateSelected
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Image between segment selected on the right and unselected on the left.
    [self.genderSegmentedControl setDividerImage:[UIImage imageNamed:@"gender-girl-active-segmented.png"] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.genderSegmentedControl setFrame:CGRectMake(self.genderSegmentedControl.frame.origin.x, self.genderSegmentedControl.frame.origin.y, self.genderSegmentedControl.frame.size.width, 62)];
    
    //Assign DatePicker to Birthday TextField
    //build our custom popover view
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    popoverView.backgroundColor = [UIColor whiteColor];
    popoverContent.view = popoverView;
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);
    
    self.dateOfBirthField.delegate = self;
    
    //Assign NSUserDefaults to defaults
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self.parentUserModel retrieveApiSavedStudents:[defaults arrayForKey:@"sons"]];
    
    if (![defaults objectForKey:@"facebookParentInfo"]) {
        [self.parentUserModel requestFacebookDataParent];
        NSLog(@"There was no facebookParentInfo in the Parent Portal!!!!!");
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(useDataLogin) 
                                                     name:@"FBParentInfoIsReady" 
                                                   object:nil];
    }else {
        [self useDataLogin];
    }
    
    
    
}

- (void)viewDidUnload
{
    [self setParentFullName:nil];
    [self setParentLocation:nil];
    [self setParentProfilePicture:nil];
    [self setEditProfileButton:nil];
    [self setBuyCoinsButton:nil];
    //TableView vars
    [self setTableView:nil];
    [self setStudentForm:nil];
    [self setViewParentPortal:nil];
    [self setTableView:nil];
    [self setStudentForm:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setDateOfBirthField:nil];
    [self setCurrentSchoolTextField:nil];
    [self setFirstNameLabel:nil];
    [self setLastNameLabel:nil];
    [self setDateOfBirthLabel:nil];
    [self setCurrentSchoolLabel:nil];
    [self setUploadPictureLabel:nil];
    [self setImageDimensionLabel:nil];
    [self setGenderSegmentedControl:nil];
    [self setStudentImageView:nil];
    [self setTakePhotoButton:nil];
    [self setStudentFormActivityIndicator:nil];
    [self setSaveStudentInfoButton:nil];
    [self setStudentMaskImageView:nil];
    [self setTwitterButton:nil];
    [self setFacebookButton:nil];
    [self setGooglePlusButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBDidUploadPhoto" 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBDidLogout" 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FBParentInfoIsReady"
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark - Popover Methods


// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    imagePickerController = nil;
    self.popoverControllerBirthday = nil;
    
}

#pragma mark - Student Form View
- (void)showStudentForm{
    
    [self.viewParentPortal addSubview:self.addStudentView];
    [self.firstNameTextField becomeFirstResponder];
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        self.studentForm.frame = CGRectMake(self.studentForm.frame.origin.x, 38, self.studentForm.frame.size.width, self.studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cancelStudentInfo:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        self.studentForm.frame = CGRectMake(self.studentForm.frame.origin.x, 738, self.studentForm.frame.size.width, self.studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeStudentFormSubView];
    }];
    
}

- (IBAction)saveStudentInfo:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        self.studentForm.frame = CGRectMake(self.studentForm.frame.origin.x, 738, self.studentForm.frame.size.width, self.studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        UIImage * image = self.studentImageView.image;
        NSDictionary * studentInfo = [[NSDictionary alloc] init];
        if ((self.firstNameTextField.text.length > 1) && (self.lastNameTextField.text.length > 1)) {
            //If there is an image, then Upload it to Facebook
            if (image) {
                                
                // Create a UIImage with the Uploaded Student picture URL.
                NSURL * url = [NSURL URLWithString:studentImageUrlStr];
                NSData * data = [NSData dataWithContentsOfURL:url];
                image = [[UIImage alloc] initWithData:data];
                
                
                //Create Student Info Dictionary with Image URL
                studentInfo = [self createStudentInfoDictionary];
                studentImageUrlStr = nil;
                
                NSLog(@"The Student Info With Image URL is %@:", studentInfo);
            }else {
                //Create Student Info Dictionary without an Image URL
                studentImageUrlStr = @" ";
                studentInfo = [self createStudentInfoDictionary];
                
                NSLog(@"The Student Info without an Image URL is %@:", studentInfo);
            }
            
            
            //Create Student Object For Piitri API
            NSDictionary * studentObject = [[NSDictionary alloc] initWithObjectsAndKeys:@"A1B2C3E4F5123",@"appID",studentInfo,@"student", nil];
            NSLog(@"The Student Object is %@:", studentObject);

            NSLog(@"Sending Student Object to API");
            
            //Send Student Objet to Model to form the URL Request
            NSMutableURLRequest * requestApi = [self.parentUserModel sendStudentToApi:studentObject];
            
            //Call the URL Connection with the Builded Request Structure
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestApi delegate:self];
            if (theConnection) {
                // Create the NSMutableData to hold the received data.
                // receivedData is an instance variable declared elsewhere.
                self.receivedData = [NSMutableData data];
                NSLog(@"The connection to Add Student has STARTED! ");
                
            } else {
                // Inform the user that the connection failed.
                NSLog(@"The connection to Add Student has FAILED!");
            }
            
        }else {
            [self removeStudentFormSubView];
            
        }
        
        
        
    }];
    
    
}


- (void)removeStudentFormSubView{
    [self.firstNameTextField resignFirstResponder];
    self.takePhotoButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"btn-camera-icon-inactive.png"]];
    self.firstNameTextField.text = nil;
    self.lastNameTextField.text = nil;
    self.dateOfBirthField.text = nil;
    self.currentSchoolTextField.text = nil;
    self.studentImageView.image = nil;
    [self.studentImageView setHidden:YES];
    [self.studentMaskImageView setHidden:YES];
    [self.addStudentView removeFromSuperview];
    
}

//Should be a Model Method ????
- (NSDictionary *)createStudentInfoDictionary{
    NSDictionary * studentInfoCreatedDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.firstNameTextField.text,@"first_name",self.lastNameTextField.text,@"last_name",self.dateOfBirthField.text,@"date_of_birth",[self genderSelection:self.genderSegmentedControl],@"gender",self.currentSchoolTextField.text,@"school",studentImageUrlStr,@"picture_url", nil];
    return studentInfoCreatedDictionary;
    
}


-(NSString *)genderSelection:(UISegmentedControl *)segmentedControl{
    NSString * stundentGender = [[NSString alloc] init];
    if ([self.genderSegmentedControl selectedSegmentIndex] == 0) {
        stundentGender = @"male";
        return stundentGender;
    }else if ([self.genderSegmentedControl selectedSegmentIndex] == 1) {
        stundentGender = @"female";
        return stundentGender;
    }else {
        stundentGender = @"undef";
        return stundentGender;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //Assign DatePicker to Birthday TextField
    //build our custom popover view
    
    DatePickerViewController* popoverContent = [[DatePickerViewController alloc] init];
    
    popoverContent =[[UIStoryboard storyboardWithName:@"MainStoryboard"
                                             bundle:nil]
                   instantiateViewControllerWithIdentifier:@"DatePickerVC"];
    
    //Set the popover delegate to self
    popoverContent.delegate = self;
    
    //resize the popover view shown
    //in the current view to the view's size
    
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 216);
    
    //Create a popover controller
    
    //dismiss existing popover
    if (self.popoverControllerBirthday)
    {
        [self.popoverControllerBirthday dismissPopoverAnimated:NO];
        self.popoverControllerBirthday = nil;
    }
    
    
    UIPopoverController *popoverControllerForDate = [[UIPopoverController alloc] initWithContentViewController:popoverContent];

    popoverControllerForDate.delegate = self;
    CGRect myFrame =textField.frame;
    myFrame.origin.x = 260;
    myFrame.origin.y = 320;
    
    [popoverControllerForDate presentPopoverFromRect:myFrame 
                                              inView:self.view 
                            permittedArrowDirections:UIPopoverArrowDirectionDown 
                                            animated:YES];
    self.popoverControllerBirthday = popoverControllerForDate;
    return NO; // tells the textfield not to start its own editing process (ie show the keyboard)
    
}

#pragma mark - Prepare for Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // dismiss existing popover
    if (self.popoverControllerBirthday)
    {
        [self.popoverControllerBirthday dismissPopoverAnimated:NO];
        self.popoverControllerBirthday = nil;
    }
    
    // retain the popover
    if ([segue.identifier isEqualToString:@"Show Photo Picker Options"]) 
    {
        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        UIPopoverController *thePopoverController = [popoverSegue popoverController];       
        [thePopoverController setDelegate:self];
        self.popoverControllerBirthday = thePopoverController;
        [segue.destinationViewController setDelegate:self];
    }
}



#pragma mark - Take Photo Methods

- (void) photoPickerViewController:(PhotoPickerViewController *)sender chosenPictureMethodStr:(NSString *) pictureMethodStr{
    [self takePhotoAction:pictureMethodStr];
}

- (void) takePhotoAction:(NSString *)sourcePhotoType {
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if ([sourcePhotoType isEqualToString:@"UIImagePickerControllerSourceTypeCamera"]) {
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        if (self.popoverControllerBirthday)
        {
            [self.popoverControllerBirthday dismissPopoverAnimated:NO];
            self.popoverControllerBirthday = nil;
        }
        
        [self presentModalViewController:imagePickerController animated:YES];
        cameraselected = YES;
    }else {
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (self.popoverControllerBirthday)
        {
            [self.popoverControllerBirthday dismissPopoverAnimated:NO];
            self.popoverControllerBirthday = nil;
        }
        
        self.popoverControllerBirthday = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        self.popoverControllerBirthday.delegate = self;
        CGRect myFrame =self.takePhotoButton.frame;
        myFrame.origin.x = 250;
        myFrame.origin.y = 119;
        
        [self.popoverControllerBirthday presentPopoverFromRect:myFrame 
                                                        inView:self.view 
                                      permittedArrowDirections:UIPopoverArrowDirectionLeft 
                                                      animated:YES];
    }

}

// Recives the message when the controller has finised
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{

	// Stablishes the image taken in the UIImageView
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
	self.studentImageView.image = nil;
    if (cameraselected) {
        [self dismissModalViewControllerAnimated:YES];
        imagePickerController = nil;
        cameraselected = NO;
    }
    if (self.popoverControllerBirthday)
    {
        [self.popoverControllerBirthday dismissPopoverAnimated:NO];
        self.popoverControllerBirthday = nil;
    }
    
    CGSize cropSize = CGSizeMake(260, 260);
    
    image = [self.parentUserModel image:image ByScalingAndCroppingForSize:cropSize];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       image, @"picture",
                                       nil];
    [self.parentUserModel uploadPhotoToFacebook:parameters];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(activateSaveButton) 
                                                 name:@"FBDidUploadPhoto" 
                                               object:nil];
    if (image) {
        
        [self.studentFormActivityIndicator startAnimating];
        self.takePhotoButton.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"icon-student-sign-up-placeholder.png"]]; 
        [self.saveStudentInfoButton setEnabled:(NO)];
    }
    tempStudentImage = image;
}


// Dismiss picker
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    if (cameraselected) {
        [self dismissModalViewControllerAnimated:YES];
        cameraselected = NO;
    }
    if (self.popoverControllerBirthday)
    {
        [self.popoverControllerBirthday dismissPopoverAnimated:NO];
        self.popoverControllerBirthday = nil;
    }
    imagePickerController = nil;
}

// Activate Save Button when the Photo has been Uploaded to Facebook
- (void)activateSaveButton {
    studentImageUrlStr = [defaults stringForKey:@"studentImageUrlStr"];
    [self.studentFormActivityIndicator stopAnimating];
    [self.saveStudentInfoButton setEnabled:(YES)];
    [self.studentMaskImageView setHidden:NO];
    [self.studentImageView setHidden:NO];
    self.studentImageView.image = tempStudentImage;
    
}

#pragma mark - Birthday DatePickerViewController Delegate Method


- (void)datePickerViewController:(DatePickerViewController *)sender chosenDateStr:(NSString *)dateStr{
    self.dateOfBirthField.text = dateStr;
}


#pragma mark - Facebook Data Use 

- (void)useDataLogin{
    
    [self.twitterButton setHidden:NO];
    [self.facebookButton setHidden:NO];
    [self.googlePlusButton setHidden:NO];
    [self.editProfileButton setHidden:NO];
    [self.buyCoinsButton setHidden:NO];
    
    id resultado = [defaults objectForKey:@"facebookParentInfo"];
    NSString * accessToken = [defaults stringForKey:kFBAccessTokenKey];
    NSLog(@"The result Data in Parent Portal is %@:", resultado);
    
    //Populate Parent Fullaname Label an Location
    self.parentFullName.text = [resultado objectForKey:@"name"];
    NSDictionary * ubicacionDic = [[NSDictionary alloc]initWithDictionary:[resultado objectForKey:@"location"]];
    self.parentLocation.text = [ubicacionDic objectForKey:@"name"];

    // Get the user's profile picture.
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&access_token=%@", accessToken]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * profilePicLarge = [[UIImage alloc] initWithData:data];

    // Use the profile picture here.
    self.parentProfilePicture.image = profilePicLarge;
    
}

- (void)changeStudentInfoForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.twitterButton setHidden:YES];
    [self.facebookButton setHidden:YES];
    [self.googlePlusButton setHidden:YES];
    [self.editProfileButton setHidden:YES];
    [self.buyCoinsButton setHidden:YES];
    
    NSDictionary * resultado = [self.parentUserModel.sons objectAtIndex:indexPath.row];
    NSLog(@"The result Data in Parent Portal is %@:", resultado);
    
    NSMutableString * fullName = [[NSMutableString alloc] initWithString:[resultado objectForKey:@"first_name"]];
    [fullName appendString:@" "];
    [fullName appendString:[resultado objectForKey:@"last_name"]];
    
    //Populate Parent Fullaname Label an Location
    self.parentFullName.text = fullName;
    self.parentLocation.text = [resultado objectForKey:@"school"];
    
    // Get the user's profile picture.
    //Next line is commented because it was generating a Warning
    //NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:[resultado objectForKey:@"picture_url"]]];
    NSURL * url = [NSURL URLWithString:[resultado objectForKey:@"picture_url"]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * profilePicLarge = [[UIImage alloc] initWithData:data];
    
    // Use the profile picture here.
    self.parentProfilePicture.image = profilePicLarge;
    
}

- (IBAction)disconnectFromFB:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cleanFacebookData) 
                                                 name:@"FBDidLogout" 
                                               object:nil];
    [self.parentUserModel logoutFromFacebook];
}

- (void)cleanFacebookData {
    //Send Student Id to Model to form the URL Request to Delete the student
    NSMutableURLRequest * requestApiLogout = [self.parentUserModel logoutFromApi];
    
    //Call the URL Connection with the Builded Request Structure
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestApiLogout delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
        NSLog(@"The connection to LOGOUT has STARTED! ");
    } else {
        // Inform the user that the connection failed.
        NSLog(@"The connection to LOGOUT has FAILED!");
    }
    
    NSLog(@"In Logout the user data is: %@", [defaults objectForKey:@"facebookParentInfo"]);
    NSLog(@"The access token is: %@", [defaults objectForKey:kFBAccessTokenKey]);
    NSLog(@"the expitation Date is: %@", [defaults objectForKey:kFBExpirationDateKey]);
    //NSLog(@"the json parent info is: %@", [defaults objectForKey:@"jsonParentInfo"]);
    NSLog(@"and the sons are: %@", [defaults objectForKey:@"sons"]);
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)backButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 1;
    }else if (section==2) {
        return [self.parentUserModel.sons count];
    }else if (section==3) {
        return 1;
    }else if (section==4) {
        return 1;
    }else if (section==5) {
        return 1;
    }else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ParentProfileCell *parent = [tableView dequeueReusableCellWithIdentifier:@"Parent"];
        if (parent==nil) {
            parent = [[ParentProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Parent"];
        }
        
        parent.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        parent.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        
        
        // Create a Dictionary From userData in UserDefaults
        NSDictionary * parentData = [[NSDictionary alloc] initWithDictionary:[defaults dictionaryForKey:@"facebookParentInfo"]];
        NSLog(@"The Data imported from Facebook in tableView:cellForRowAtIndexPath: section 0 is %@:", parentData);

        // Take out the Name of the Parent to Draw in the Cell
        parent.parentNameCellLabel.text = [parentData objectForKey:@"name"];
        // Get the Parent Small profile picture.
        NSString * accessToken =[defaults stringForKey:kFBAccessTokenKey];
        NSURL * smallUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=small&access_token=%@", accessToken]];
        NSData * smalldata = [NSData dataWithContentsOfURL:smallUrl];
        UIImage * parentImage = [[UIImage alloc] initWithData:smalldata];
        parent.parentCellImageView.image = parentImage;
        
        return parent;
        
    }else if (indexPath.section==1) {
        MainSideMenuItemCell *accounts = [tableView dequeueReusableCellWithIdentifier:@"Accounts"];
        if (accounts==nil) {
            accounts = [[MainSideMenuItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accounts"];
        }
        
        accounts.mainItemCellLabel.text = @"Accounts";
        
        accounts.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        accounts.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        return accounts;
        
    }else if (indexPath.section==2) {
        StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell==nil) {
            cell = [[StudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-student-unselected.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        
        // Create a Dictionary From sons
        NSMutableArray * sonsArray = [[NSMutableArray alloc] initWithArray: self.parentUserModel.sons];
        NSDictionary *studentNameAndImageObjectDict = [[NSDictionary alloc] initWithDictionary:[sonsArray objectAtIndex:indexPath.row]];
        
        // Take out the Name of the Student to Draw in the Cell
        //Next line is commented because it was generating a Warning
        //NSMutableString * studentName = [[NSMutableString alloc] initWithFormat:(NSString *)[studentNameAndImageObjectDict objectForKey:@"first_name"]];
        NSMutableString * studentName = [[studentNameAndImageObjectDict objectForKey:@"first_name"] mutableCopy];
        [studentName appendString:@" "];
        [studentName appendString:[studentNameAndImageObjectDict objectForKey:@"last_name"]];
        cell.studentNameCellLabel.text = studentName;
        
        //Student Small Picture
        if ([studentNameAndImageObjectDict objectForKey:@"picture_url"]) {
            //Take out the Url of the Facebook Student Photo to Draw in the Cell
            //Next line is commented because it was generating a Warning
            //NSString * studentPictureUrl = [[NSMutableString alloc] initWithFormat:(NSString *)[studentNameAndImageObjectDict objectForKey:@"picture_url"]];
            NSString * studentPictureUrl = [[studentNameAndImageObjectDict objectForKey:@"picture_url"] mutableCopy];
            // Create a UIImage with the Uploaded Student picture URL.
            NSURL * url = [NSURL URLWithString:studentPictureUrl];
            NSData * data = [NSData dataWithContentsOfURL:url];
            UIImage * studentImage = [[UIImage alloc] initWithData:data];
            
            cell.studentCellImageView.image = studentImage;
            
        }else {
            cell.studentCellImageView.image = nil;
        }
        
        return cell;
        
    }else if (indexPath.section==3){
        AddStudentCell *addStudent = [tableView dequeueReusableCellWithIdentifier:@"Add Student"];
        if (addStudent==nil) {
            addStudent = [[AddStudentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Add Student"];
        }
        addStudent.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-inactive.png"]];
        addStudent.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-active.png"]];
        return addStudent;
        
    }else if (indexPath.section==4) {
        MainSideMenuItemCell *myLessons = [tableView dequeueReusableCellWithIdentifier:@"Accounts"];
        if (myLessons==nil) {
            myLessons = [[MainSideMenuItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accounts"];
        }
        myLessons.mainItemCellLabel.text = @"My Lessons";
        
        myLessons.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        myLessons.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        return myLessons;
    }else if (indexPath.section==5){
        MainSideMenuItemCell *store = [tableView dequeueReusableCellWithIdentifier:@"Accounts"];
        if (store==nil) {
            store = [[MainSideMenuItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accounts"];
        }
        store.mainItemCellLabel.text = @"Store";
        
        store.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        store.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        return store;
    }else {
        return nil;
    }
    
    
    
    
}
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 if (indexPath.section==0){
 cell.backgroundView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tab-unselected.png"]];
 cell.selectedBackgroundView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tab-hightlight.png"]];
 
 */
/*cell.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
 cell.textLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
 cell.textLabel.textColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
 cell.detailTextLabel.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
 cell.detailTextLabel.textColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];*/
/*}else if (indexPath.section==2) {
 cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tab-hightlight.png"]];
 
 }
 
 }*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section==2) {
        return YES;
    }else {
        return NO;
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * studentId = [[self.parentUserModel.sons objectAtIndex:indexPath.row] objectForKey:@"_id"];
        NSLog(@"Hasta aca vamos bien con el DELETE");
        
        [self.parentUserModel.sons removeObjectAtIndex:indexPath.row];
        NSLog(@"Hasta aca todavia vamos bien con el DELETE");
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //Send Student Id to Model to form the URL Request to Delete the student
        NSMutableURLRequest * requestApiDelete = [self.parentUserModel deleteStudentFromApi:studentId forRowAtIndexPath:indexPath];
        
        //Call the URL Connection with the Builded Request Structure
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestApiDelete delegate:self];
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            self.receivedData = [NSMutableData data];
            NSLog(@"The connection to DELETE has STARTED! ");
            
        } else {
            // Inform the user that the connection failed.
            NSLog(@"The connection to DELETE has FAILED!");
        }

        
        //indexPathDeleteStudent = nil;
        /*
        [self deleteConfirmationAlert];
        indexPathDeleteStudent = indexPath;
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(deleteStudentforRowAtIndexPath:) 
                                                     name:@"DeleteStudent" 
                                                   object:nil];*/
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
/*
-(void)deleteConfirmationAlert{
    UIAlertView * deleteAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" 
                                                           message:@"Deleting a user can not be undone" 
                                                          delegate:self 
                                                 cancelButtonTitle:@"Acept" 
                                                 otherButtonTitles:@"Cancel",nil];
    [deleteAlert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        deleteStudent = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteStudent" object:self];
    }else {
        indexPathDeleteStudent = nil;
    }
}

-(void)deleteStudentforRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * studentId = [[sons objectAtIndex:indexPath.row] objectForKey:@"_id"];
    NSLog(@"Hasta aca vamos bien con el DELETE");
    
    [sons removeObjectAtIndex:indexPath.row];
    NSLog(@"Hasta aca todavia vamos bien con el DELETE");
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self deleteStudentFromApi:studentId forRowAtIndexPath:indexPath];
    indexPathDeleteStudent = nil;
}*/


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}*/
                                                                                                        

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        [self useDataLogin];
    }else if (indexPath.section==2) {
        
        [self changeStudentInfoForRowAtIndexPath:indexPath];
        
    }else if (indexPath.section==3) {
        
        [self showStudentForm];
        
    }
    
}

#pragma mark - NSURLResponse Delegate Metods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    // receivedData is an instance variable declared on top of this class.
    
    [self.receivedData setLength:0];
    /*NSString * responseStatusCodeStr = [[NSString alloc] initWith:(NSURLResponse *)response];*/
    NSLog(@"The URL Response is :%@", response);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"Status code %d", [httpResponse statusCode]);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    // Append the new data to receivedData.
    
    // receivedData is an instance variable declared on top of this class.
    
    [self.receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection

  didFailWithError:(NSError *)error

{
    // inform the user
    
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    // do something with the data
    
    // receivedData is declared as a method instance on top of this class.
    NSError* error = nil;
    NSError* errorJson = nil;
    NSLog(@"Succeeded! Received %d bytes of data in Parent Portal ",[self.receivedData length]);
    
    NSString * requestMethod = [[NSString alloc] initWithString:connection.originalRequest.HTTPMethod];
    NSLog(@"And the request Method in Parent Portal was %@",requestMethod);
    
    if ([connection.originalRequest.HTTPMethod isEqualToString:@"POST"]) {
        
        NSString * originalRequestUrlStr = [[NSString alloc] initWithContentsOfURL:connection.originalRequest.URL encoding:NSUTF8StringEncoding error:&error];
        
        if (error != nil) {
            NSLog(@"We have the following error when creating the originalRequestUrlStr in Login: %@", error);
        }
        
        NSLog(@"The Original Request URL is%@",originalRequestUrlStr);
        NSLog(@"The Original Direct Request URL is: %@",connection.originalRequest.URL);
        
        NSDictionary * receivedDataDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
        
        if (errorJson != nil) {
            NSLog(@"We have the following error when creating the JSON object in Add Student: %@", errorJson);
        }
        //Print the received Data
        NSLog(@"The response to the Add Student API request is: %@", receivedDataDict);
        //Insert New Student Object in Sons Array
        NSLog(@"Going to call insertNewStudentInSons Method");
        
        NSLog(@"The Sons Array Before API Response is %@:", [self.parentUserModel sons]);
        
        [self.parentUserModel insertNewStudentInSons:receivedDataDict];
        
        NSLog(@"The Sons Array after API Response is %@:", [self.parentUserModel sons]);
        
        //Insert Row in Table View
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"We are good saving the student form until here");
        
        [self removeStudentFormSubView];
        
    }else if ([connection.originalRequest.HTTPMethod isEqualToString:@"DELETE"]) {
        NSMutableArray * receivedDataArray = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        if (error != nil) {
            NSLog(@"We have the following error when creating the JSON object in DELETE: %@", error);
        }
        //Print the received Data
        NSLog(@"The response to the DELETE Student API request is: %@", receivedDataArray);
        
        NSLog(@"The Sons Array after API DELETE Response is %@:", [self.parentUserModel sons]);
        
    }else if ([connection.originalRequest.HTTPMethod isEqualToString:@"GET"]) {
        NSLog(@"The Logout Connection is: %@", connection.currentRequest.allHTTPHeaderFields);
    }
}


@end
