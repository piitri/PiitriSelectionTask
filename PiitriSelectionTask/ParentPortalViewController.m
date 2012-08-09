//
//  ParentPortalViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "ParentPortalViewController.h"
#import "Facebook+Singleton.h"
#import "Cell.h"

@interface ParentPortalViewController (){
    NSUserDefaults * defaults;
    NSMutableArray *_objects;
    NSMutableArray * sons;
    NSMutableArray * studentsNamesAndImages;
    NSString * studentImageUrlStr;
    BOOL photoUpload;
    UIImage * tempStudentImage;
    NSMutableData * receivedData;//instance variable to recieve the response of the API Call
    
}
- (void)configureView;
@end

@implementation ParentPortalViewController


@synthesize parentFullName = _parentFullName;
@synthesize parentSmallName = _parentSmallName;
@synthesize parentLocation = _parentLocation;
@synthesize editProfileButton = _editProfileButton;
@synthesize buyCoinsButton = _buyCoinsButton;
@synthesize parentEmail = _parentEmail;
@synthesize parentBirthday = _parentBirthday;
@synthesize parentProfilePicture = _parentProfilePicture;
@synthesize smallParentProfilePicture = _smallParentProfilePicture;
@synthesize cajaTextoParentPortal = _cajaTextoParentPortal;

//Vars for TableView
@synthesize tableView = _tableView;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

//Views
@synthesize studentForm = _studentForm;
@synthesize addStudentView = _addStudentView;
@synthesize viewParentPortal = _viewParentPortal;
//Student Form Variables
@synthesize saveStudentInfoButton = _saveStudentInfoButton;
@synthesize takePhotoButton = _takePhotoButton;
@synthesize uploadPictureLabel = _uploadPictureLabel;
@synthesize imageDimensionLabel = _imageDimensionLabel;
@synthesize studentImageView = _studentImageView;
@synthesize genderSegmentedControl = _genderSegmentedControl;
@synthesize firstNameLabel = _firstNameLabel;
@synthesize firstNameTextField = _firstNameTextField;
@synthesize lastNameLabel = _lastNameLabel;
@synthesize lastNameTextField = _lastNameTextField;
@synthesize dateOfBirthLabel = _dateOfBirthLabel;
@synthesize dateOfBirthField = _dateOfBirthField;
@synthesize birthdayDatePicker = _birthdayDatePicker;
@synthesize currentSchoolLabel = _currentSchoolLabel;
@synthesize currentSchoolTextField = _currentSchoolTextField;
@synthesize studentFormActivityIndicator = _studentFormActivityIndicator;


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
    photoUpload = NO;
	// Do any additional setup after loading the view.    
    self.parentFullName.font = [UIFont fontWithName:@"MetaPlus" size:30];
    self.parentSmallName.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    self.parentLocation.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    
    //TableView Customization
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //Student Form Design
    
    self.uploadPictureLabel.font = [UIFont fontWithName:@"MetaPlus" size:18];
    self.imageDimensionLabel.font = [UIFont fontWithName:@"MetaPlus" size:12];
    self.firstNameLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.lastNameLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.dateOfBirthLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    self.currentSchoolLabel.font = [UIFont fontWithName:@"MetaPlus" size:14];
    CGRect firstFrameRect = _firstNameTextField.frame;
    firstFrameRect.size.height = 60;
    _firstNameTextField.frame = firstFrameRect;
    
    CGRect lastFrameRect = _lastNameTextField.frame;
    lastFrameRect.size.height = 60;
    _lastNameTextField.frame = lastFrameRect;
    
    CGRect birthFrameRect = _dateOfBirthField.frame;
    birthFrameRect.size.height = 60;
    _dateOfBirthField.frame = birthFrameRect;
    
    CGRect schoolFrameRect = _currentSchoolTextField.frame;
    schoolFrameRect.size.height = 60;
    _currentSchoolTextField.frame = schoolFrameRect;
    
    UIColor *backgroundAddStudent = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"light-box-black.png"]];
    _addStudentView.backgroundColor = backgroundAddStudent;
    UIColor *backgroundStudentForm = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"student-form.png"]];
    _studentForm.backgroundColor = backgroundStudentForm;
    
    //Segmented Control customization
    // Image between two unselected segments.
    [_genderSegmentedControl setDividerImage:[UIImage imageNamed:@"gender-inactive-segmented.png"] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // Image between segment selected on the left and unselected on the right.
    [_genderSegmentedControl setDividerImage:[UIImage imageNamed:@"gender-boy-active-segmented.png"] forLeftSegmentState:UIControlStateSelected
                      rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // Image between segment selected on the right and unselected on the right.
    [_genderSegmentedControl setDividerImage:[UIImage imageNamed:@"gender-girl-active-segmented.png"] forLeftSegmentState:UIControlStateNormal
                      rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_genderSegmentedControl setFrame:CGRectMake(_genderSegmentedControl.frame.origin.x, _genderSegmentedControl.frame.origin.y, _genderSegmentedControl.frame.size.width, 62)];
    
    //Assign DatePicker to Birthday TextField
    self.dateOfBirthField.inputView = self.birthdayDatePicker;

    
    /*[_genderSegmentedControl setBackgroundImage:[UIImage imageNamed:@"gender-boy-active.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];*/
    
    /*_addStudentView.transform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 360 );*/

    
    
    self.editProfileButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    self.buyCoinsButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    [self configureView];   

    defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"facebookParentInfo"]) {
        [self requestFacebookData];
    }else {
        [self useDatosLogin:[defaults objectForKey:@"facebookParentInfo"] withToken:(NSString *) [defaults objectForKey:kFBAccessTokenKey]];
    }
    
    
    
}

- (void)viewDidUnload
{
    [self setParentFullName:nil];
    [self setParentLocation:nil];
    [self setParentProfilePicture:nil];
    [self setCajaTextoParentPortal:nil];
    [self setParentEmail:nil];
    [self setParentBirthday:nil];
    [self setSmallParentProfilePicture:nil];
    [self setParentSmallName:nil];
    [self setEditProfileButton:nil];
    [self setBuyCoinsButton:nil];
    //TableView vars
    [self setTableView:nil];
    [self setDetailDescriptionLabel:nil];
    [self setStudentForm:nil];
    [self setViewParentPortal:nil];
    [self setTableView:nil];
    [self setDetailDescriptionLabel:nil];
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
    [self setBirthdayDatePicker:nil];
    [self setStudentFormActivityIndicator:nil];
    [self setSaveStudentInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    /*return YES;*/
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertNewStudentInSons:(NSDictionary *)student
{
    if (!sons) {
        sons = [[NSMutableArray alloc] init];
    }
    [sons insertObject:student atIndex:0];
}

- (void)insertNewStudentNameAndImage:(NSDictionary *)studentNameAndImage
{
    if (!studentsNamesAndImages) {
        studentsNamesAndImages = [[NSMutableArray alloc] init];
    }
    [studentsNamesAndImages insertObject:studentNameAndImage atIndex:0];
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    /*if (self.masterPopoverController != nil) {
     [self.masterPopoverController dismissPopoverAnimated:YES];
     } */       
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return sons.count;
    }else if (section==2) {
        return 1;
    }else if (section==3) {
        return 1;
    }else if (section==4) {
        return 1;
    }else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *accounts = [tableView dequeueReusableCellWithIdentifier:@"Accounts"];
        if (accounts==nil) {
            accounts = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accounts"];
        }
        accounts.textLabel.text = @"Accounts";
        accounts.textLabel.font = [UIFont fontWithName:@"MetaPlus" size:20];
        accounts.textLabel.textColor = [UIColor whiteColor];
        accounts.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        accounts.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        return accounts;
        
    }else if (indexPath.section==1) {
        Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell==nil) {
            cell = [[Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.studentNameCellLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
        cell.studentNameCellLabel.textColor = [UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-student-unselected.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        
        // Create a Dictionary From studentsNamesAndImages
        NSDictionary *studentNameAndImageObjectDict = [[NSDictionary alloc] initWithDictionary:[studentsNamesAndImages objectAtIndex:indexPath.row]];
        
        // Take out the Name of the Student to Draw in the Cell
        NSString * studentName = [[NSMutableString alloc] initWithFormat:(NSString *)[studentNameAndImageObjectDict objectForKey:@"studentName"]];
        cell.studentNameCellLabel.text = studentName;
        
        if ([studentNameAndImageObjectDict objectForKey:@"studentImageUrl"]) {
            //Take out the Url of the Facebook Student Photo to Draw in the Cell
            NSString * studentPictureUrl = [[NSMutableString alloc] initWithFormat:(NSString *)[studentNameAndImageObjectDict objectForKey:@"studentImageUrl"]];
            
            // Create a UIImage with the Uploaded Student picture URL.
            NSURL * url = [NSURL URLWithString:studentPictureUrl];
            NSData * data = [NSData dataWithContentsOfURL:url];
            UIImage * studentImage = [[UIImage alloc] initWithData:data];
            
            cell.studentCellImageView.image = studentImage;
        }else {
            cell.studentCellImageView.image = nil;
        }
        
        
        return cell;
    }else if (indexPath.section==2){
        UITableViewCell *addStudent = [tableView dequeueReusableCellWithIdentifier:@"Add Student"];
        if (addStudent==nil) {
            addStudent = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Add Student"];
        }
        /*addStudent.textLabel.text = @"+Add Student";*/
        addStudent.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-inactive.png"]];
        addStudent.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-add-student-active.png"]];
        return addStudent;
        
    }else if (indexPath.section==3) {
        UITableViewCell *myLessons = [tableView dequeueReusableCellWithIdentifier:@"Accounts"];
        if (myLessons==nil) {
            myLessons = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accounts"];
        }
        myLessons.textLabel.text = @"My Lessons";
        myLessons.textLabel.font = [UIFont fontWithName:@"MetaPlus" size:20];
        myLessons.textLabel.textColor = [UIColor whiteColor];
        myLessons.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        myLessons.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        return myLessons;
    }else if (indexPath.section==4){
        UITableViewCell *store = [tableView dequeueReusableCellWithIdentifier:@"Accounts"];
        if (store==nil) {
            store = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accounts"];
        }
        store.textLabel.text = @"Store";
        store.textLabel.font = [UIFont fontWithName:@"MetaPlus" size:20];
        store.textLabel.textColor = [UIColor whiteColor];
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
    if (indexPath.section==1) {
        return YES;
    }else {
        return NO;
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Add Student"];
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tab-hightlight.png"]];
    }else if (indexPath.section==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tab-hightlight.png"]];
    }
    return indexPath;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        /*if (!_objects) {
            _objects = [[NSMutableArray alloc] init];
        }
        [_objects insertObject:[NSDate date] atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationAutomatic];*/

        [self showStudentForm];
        
        
        
    }else if (indexPath.section==1) {
        /*NSDate *object = [_objects objectAtIndex:indexPath.row];*/

        NSString * studentName = [[studentsNamesAndImages objectAtIndex:indexPath.row] objectForKey:@"studentName"];
        self.detailItem = studentName;
    }
    
}
#pragma mark - Student Form View
- (void)showStudentForm{
    /*[UIView transitionFromView:self.viewParentPortal toView:self.addStudentView duration:2 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        
    }];*/
    
    [self.viewParentPortal addSubview:self.addStudentView];
    [_firstNameTextField becomeFirstResponder];
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        _studentForm.frame = CGRectMake(_studentForm.frame.origin.x, 38, _studentForm.frame.size.width, _studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cancelStudentInfo:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        _studentForm.frame = CGRectMake(_studentForm.frame.origin.x, 738, _studentForm.frame.size.width, _studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        [_firstNameTextField resignFirstResponder];
        _firstNameTextField.text = nil;
        _lastNameTextField.text = nil;
        _dateOfBirthField.text = nil;
        _currentSchoolTextField.text = nil;
        _studentImageView.image = nil;
        [self.addStudentView removeFromSuperview];
    }];
    
}

- (IBAction)saveStudentInfo:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        _studentForm.frame = CGRectMake(_studentForm.frame.origin.x, 738, _studentForm.frame.size.width, _studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        UIImage * image = _studentImageView.image;
        NSDictionary * studentInfo = [[NSDictionary alloc] init];
        if ((self.firstNameTextField.text.length > 1) && (self.lastNameTextField.text.length > 1)) {
            //If there is an image, then Upload it to Facebook
            /*NSString *boolValue = [[NSString alloc] init];
            if (photoUpload) {
                boolValue = @"Yes";
            }else {
                boolValue = @"No";
            }
            NSLog(@"The photoUpload value in saveStudentInfo before is: %@", boolValue);*/
            if (image) {
                /*NSLog(@"Inside if(image)");
                while (!photoUpload) {
                    [self.studentFormActivityIndicator startAnimating];
                    NSLog(@"Inside while (!photoUpload)");
                    if (photoUpload) {
                        boolValue = @"Yes";
                    }else {
                        boolValue = @"No";
                    }
                    NSLog(@"The photoUpload value in saveStudentInfo in While is: %@", boolValue);
                }
                NSLog(@"Outside while (!photoUpload)");*/
                
                // Create a UIImage with the Uploaded Student picture URL.
                NSURL * url = [NSURL URLWithString:studentImageUrlStr];
                NSData * data = [NSData dataWithContentsOfURL:url];
                image = [[UIImage alloc] initWithData:data];
                
                //Create Student Info Dictionary with Image URL
                studentInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_firstNameTextField.text,@"first_name",_lastNameTextField.text,@"last_name",_dateOfBirthField.text,@"date_of_birth",[self genderSelection:_genderSegmentedControl],@"gender",_currentSchoolTextField.text,@"school",studentImageUrlStr,@"picture_url", nil];
                NSLog(@"The Student Info With Image URL is %@:", studentInfo);
                /*photoUpload = NO;
                if (photoUpload) {
                    boolValue = @"Yes";
                }else {
                    boolValue = @"No";
                }
                 NSLog(@"The photoUpload value in saveStudentInfo after is: %@", boolValue);*/
            }else {
                //Create Student Info Dictionary without an Image URL
                studentInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_firstNameTextField.text,@"first_name",_lastNameTextField.text,@"last_name",_dateOfBirthField.text,@"date_of_birth",[self genderSelection:_genderSegmentedControl],@"gender",_currentSchoolTextField.text,@"school",@"",@"picture_url", nil];
                NSLog(@"The Student Info without an Image URL is %@:", studentInfo);
            }
            
            
            //Create Student Object For Piitri API
            NSDictionary * studentObject = [[NSDictionary alloc] initWithObjectsAndKeys:@"A1B2C3E4F5123",@"appID",studentInfo,@"student", nil];
            NSLog(@"The Student Object is %@:", studentObject);
            
            //Insert New Student Object in Sons Array
            [self insertNewStudentInSons:studentObject];
            NSLog(@"The Sons Array is %@:", sons);
            
            // Save Name, Image and Image URL to display in Parent Portal TableView
            //Create Cell Student Name
            NSMutableString * studentName = [[NSMutableString alloc] initWithString:self.firstNameTextField.text];
            [studentName appendString:@" "];
            [studentName appendString:self.lastNameTextField.text];
            
            //Create Cell Student Image
            UIImage * studentImage = image;
            
            //Create Cell Student Name and Image Dictionary
            NSDictionary * studentNameAndImageDict = [[NSDictionary alloc] initWithObjectsAndKeys:studentName,@"studentName", studentImage, @"studentImage",studentImageUrlStr,@"studentImageUrl", nil];
            [self insertNewStudentNameAndImage:studentNameAndImageDict];
            
            //Insert Row in Table View
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self sendStudentToApi];
            
        }
        
        [_firstNameTextField resignFirstResponder];
        _firstNameTextField.text = nil;
        _lastNameTextField.text = nil;
        _dateOfBirthField.text = nil;
        _currentSchoolTextField.text = nil;
        _studentImageView.image = nil;
        [self.addStudentView removeFromSuperview];
        
    }];
    
    
}

-(NSString *)genderSelection:(UISegmentedControl *)segmentedControl{
    NSString * stundentGender = [[NSString alloc] init];
    if ([_genderSegmentedControl selectedSegmentIndex] == 0) {
        stundentGender = @"male";
        return stundentGender;
    }else if ([_genderSegmentedControl selectedSegmentIndex] == 1) {
        stundentGender = @"female";
        return stundentGender;
    }else {
        stundentGender = @"undef";
        return stundentGender;
    }
    
}


#pragma mark - Create Student in API
 
- (NSString *)sendStudentToApi{
    //Post Student info to Node.js API
    
    //Create user Dictionary with email, location, name and picture_url
    NSDictionary * user = [[NSDictionary alloc] initWithObjectsAndKeys:sons,@"sons", nil];
    
    
    //Parse the jsonDict to JSON data with native NSJSONSerialization and create a NSString
    NSError* error = nil;
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:user options:kNilOptions error:&error];
    NSString *jsonRequestAscii = [[NSString alloc] initWithData:jsonRequestData encoding:NSASCIIStringEncoding]; //cambié de utf8 a ascii
    NSString *jsonRequestUtf8 = [[NSString alloc] initWithData:jsonRequestData encoding:NSUTF8StringEncoding];
    NSLog(@"The JSON string for the request to the API in ParentPortalViewController.m is: %@", jsonRequestAscii);
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/student"];
    
    //Create the URL Request
    NSMutableURLRequest * requestApi = [NSMutableURLRequest requestWithURL:urlRequestLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSLog(@"el jsonRequest en ASCII es: %@ y su longitud es: %i",jsonRequestAscii,[jsonRequestAscii length]);
    [requestApi setHTTPMethod:@"POST"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //Buid the Request Data
    NSData  * requestData = [NSData dataWithBytes:[jsonRequestUtf8 UTF8String] length:[jsonRequestAscii length]];
    [requestApi setHTTPBody:requestData];
    
    
    //Call the URL Connection with the Builded Request Structure
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestApi delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
        NSLog(@"The connection has STARTED! ");
        return @"STARTED";
        
    } else {
        // Inform the user that the connection failed.
        NSLog(@"The connection has FAILED!");
        return @"FAILED";
    }
}
 
 

#pragma mark - NSURLResponse Delegate Metods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    // receivedData is an instance variable declared on top of this class.
    
    [receivedData setLength:0];
    /*NSString * responseStatusCodeStr = [[NSString alloc] initWith:(NSURLResponse *)response];*/
    NSLog(@"The URL Response is :%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    // Append the new data to receivedData.
    
    // receivedData is an instance variable declared on top of this class.
    
    [receivedData appendData:data];
    
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
    NSLog(@"Succeeded! Received %d bytes of data in Parent Portal ",[receivedData length]);
    NSDictionary * receivedDataDict = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"Se produjo el siguiete error al crear el JSON: %@", error);
    }
    //Print the received Data
    NSLog(@"La respuesta a el request del API es: %@", receivedDataDict);
    //Print the received Cookie
    NSHTTPCookie * galletas = (NSHTTPCookie *)[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/studentn"]];
    NSLog(@"The cookies of Create Student Response are: %@", galletas);
    
    
    
}



#pragma mark - Take Photo Methods

- (IBAction)takePhotoAction:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;	
    picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;	
	[self presentModalViewController:picker animated:YES];	

}




// Recives the message when the controller has finised
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
	// Remove View From Controller 
	[picker dismissModalViewControllerAnimated:YES];
	// Stablishes the image taken in the UIImageView
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
	self.studentImageView.image = nil;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       image, @"picture",
                                       nil];
    [self uploadPhotoToFacebook:parameters];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(activateSaveButton) 
                                                 name:@"FBDidUploadPhoto" 
                                               object:nil];
    if (image) {
        
        [self.studentFormActivityIndicator startAnimating];
        [self.saveStudentInfoButton setEnabled:(NO)];
    }
    tempStudentImage = image;
}

- (void)activateSaveButton {
    [self.studentFormActivityIndicator stopAnimating];
    [self.saveStudentInfoButton setEnabled:(YES)];
    self.studentImageView.image = tempStudentImage;
}

#pragma mark - Birthday DatePicker

- (IBAction)birthdayDateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    self.dateOfBirthField.text = [dateFormatter stringFromDate:picker.date];

}
     
#pragma mark - Facebook Data Request


- (void)requestFacebookData {
    [[Facebook shared] requestWithGraphPath:@"me?fields=id,email,name,picture,birthday,location" 
                                andDelegate:self];
    
}

- (void)uploadPhotoToFacebook:(NSMutableDictionary *)params{
    [[Facebook shared] requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}

- (void)useDatosLogin:(id)resultado withToken:(NSString *) accessToken{
    //Populate Text Box
    NSLog(@"Los Datos de resultado en el Parent Portal son %@:", resultado);
    NSMutableString * textoDeCaja = [[NSMutableString alloc] init];
    [textoDeCaja appendString:@"Welcome: "];
    [textoDeCaja appendString:[resultado objectForKey:@"name"]];
    [textoDeCaja appendString:@" \nThis is your Piitri Portal"];
    
    
    self.cajaTextoParentPortal.text = textoDeCaja;
    
    //Populate Parent Fullaname Label an Location
    _parentFullName.text = [resultado objectForKey:@"name"];
    NSDictionary * ubicacionDic = [[NSDictionary alloc]initWithDictionary:[resultado objectForKey:@"location"]];
    _parentLocation.text = [ubicacionDic objectForKey:@"name"];
    _parentSmallName.text = [resultado objectForKey:@"name"];
    
    //Poulate E-mail label
    _parentEmail.text = [resultado objectForKey:@"email"];
    
    //Populate Birthday label
    _parentBirthday.text = [resultado objectForKey:@"birthday"];

    // Get the user's profile picture.
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&access_token=%@", accessToken]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * profilePicLarge = [[UIImage alloc] initWithData:data];
    
    // Get the user's Small profile picture.
    NSURL * smallUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=small&access_token=%@", accessToken]];
    NSData * smalldata = [NSData dataWithContentsOfURL:smallUrl];
    UIImage * profilePicSmall = [[UIImage alloc] initWithData:smalldata];

    
    // Use the profile picture here.
    /*parentProfilePicture.layer.cornerRadius = 9.0;
    parentProfilePicture.layer.masksToBounds = YES;
    parentProfilePicture.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.85].CGColor;
    parentProfilePicture.layer.borderWidth = 3.0;*/
    _parentProfilePicture.image = profilePicLarge;
    

    _smallParentProfilePicture.image = profilePicSmall;
    
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"FB request OK");
    NSLog(@"FB request URL in ParentPortal is %@",request.url);
    NSString * tokenDeAcceso =[defaults objectForKey:kFBAccessTokenKey];
    
    if([request.url rangeOfString:@"me?fields=id,email"].location != NSNotFound) {
        NSDictionary * userData = [[NSDictionary alloc] initWithDictionary:result];
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userData forKey:@"facebookParentInfo"];
        [defaults synchronize];
        NSLog(@"La url del request en ParentPortal.m es: %@", request.url);
        NSLog(@"FB el request result en ParentPortal.m es: %@", userData);
        [self useDatosLogin:userData withToken:tokenDeAcceso];
    }else if ([request.url rangeOfString:@"me/photos"].location != NSNotFound) {
        
        NSDictionary * photoResultDict = [[NSDictionary alloc] initWithDictionary:result];
        NSLog(@"The result in ParentPortal.m is: %@", photoResultDict);
        //Save the Facebook Photo ID
        NSString *photoIdStr = [[NSString alloc] initWithFormat:[photoResultDict objectForKey:@"id"]];
        // Save the Uploaded Student picture URL.
        NSString *urlStr = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=thumbnail&access_token=%@",photoIdStr, tokenDeAcceso];
        studentImageUrlStr = urlStr;
        /*NSString *boolValue = [[NSString alloc] init];
        if (photoUpload) {
            boolValue = @"Yes";
        }else {
            boolValue = @"No";
        }
        NSLog(@"The photoUpload value before is: %@", boolValue);
        photoUpload = YES;
        if (photoUpload) {
            boolValue = @"Yes";
        }else {
            boolValue = @"No";
        }
        NSLog(@"The photoUpload value after is: %@", boolValue);*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidUploadPhoto" object:self];
    }
    
}



- (IBAction)disconnectFromFB:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cleanFacebookData) 
                                                 name:@"FBDidLogout" 
                                               object:nil];
    [[Facebook shared] logout];
}
- (void)cleanFacebookData {
    /*defaults = [NSUserDefaults standardUserDefaults];*/
    [defaults removeObjectForKey:@"facebookParentInfo"];
    [defaults synchronize];
    NSLog(@"En Logout los datos de usuario son: %@", [defaults objectForKey:@"facebookParentInfo"]);
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)backButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
