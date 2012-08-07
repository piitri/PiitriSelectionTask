//
//  ParentPortalViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "ParentPortalViewController.h"
#import "Facebook+Singleton.h"

@interface ParentPortalViewController (){
    NSMutableArray *_objects;
    NSMutableArray * sons;
    NSMutableArray *studentsNames;
    
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
@synthesize currentSchoolLabel = _currentSchoolLabel;
@synthesize currentSchoolTextField = _currentSchoolTextField;


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
    
    /*[_genderSegmentedControl setBackgroundImage:[UIImage imageNamed:@"gender-boy-active.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];*/
    
    /*_addStudentView.transform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 360 );*/

    
    
    self.editProfileButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    self.buyCoinsButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    [self configureView];   

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
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

- (void)insertNewStudent:(NSDictionary *)student
{
    if (!sons) {
        sons = [[NSMutableArray alloc] init];
    }
    [sons insertObject:student atIndex:0];
}

- (void)insertNewStudentName:(NSMutableString *)studentName
{
    if (!studentsNames) {
        studentsNames = [[NSMutableArray alloc] init];
    }
    [studentsNames insertObject:studentName atIndex:0];
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
        return sons.count;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
        cell.textLabel.textColor = [UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-unselected.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-hightlight.png"]];
        
        NSDictionary *studentObjectDict = [[NSDictionary alloc] initWithDictionary:[sons objectAtIndex:indexPath.row]];
        NSDictionary *studentInfoDict = [[NSDictionary alloc] initWithDictionary:[studentObjectDict objectForKey:@"student"]];
        NSMutableString * studentName = [[NSMutableString alloc] initWithFormat:(NSString *)[studentInfoDict objectForKey:@"first_name"]];
        [studentName appendString:@" "];
        [studentName appendString:[studentInfoDict objectForKey:@"last_name"]];
        cell.textLabel.text = studentName;
        [self insertNewStudentName:studentName];
        /*NSDate *object = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.text = [object description];*/
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
    }else {
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
    if (indexPath.section==0) {
        return NO;
    }else if (indexPath.section==1) {
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

        NSString * studentName = [studentsNames objectAtIndex:indexPath.row];
        self.detailItem = studentName;
    }
    
}
#pragma mark - Student Form View
- (void)showStudentForm{
    /*[UIView transitionFromView:self.viewParentPortal toView:self.addStudentView duration:2 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        
    }];*/
    
    [self.viewParentPortal addSubview:self.addStudentView];
    [_firstNameTextField becomeFirstResponder];
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        _studentForm.frame = CGRectMake(_studentForm.frame.origin.x, 38, _studentForm.frame.size.width, _studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cancelStudentInfo:(id)sender {
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        _studentForm.frame = CGRectMake(_studentForm.frame.origin.x, 738, _studentForm.frame.size.width, _studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        [_firstNameTextField resignFirstResponder];
        _firstNameTextField.text = nil;
        _lastNameTextField.text = nil;
        _dateOfBirthField.text = nil;
        _currentSchoolTextField.text = nil;
        [self.addStudentView removeFromSuperview];
    }];
    
}

- (IBAction)saveStudentInfo:(id)sender {
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        _studentForm.frame = CGRectMake(_studentForm.frame.origin.x, 738, _studentForm.frame.size.width, _studentForm.frame.size.height);
    } completion:^(BOOL finished) {
        NSDictionary * studentInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_firstNameTextField.text,@"first_name",_lastNameTextField.text,@"last_name",_dateOfBirthField.text,@"date_of_birth",[self genderSelection:_genderSegmentedControl],@"gender",_currentSchoolTextField.text,@"school", nil];
        
        NSLog(@"The Student Info is %@:", studentInfo);
        NSDictionary * studentObject = [[NSDictionary alloc] initWithObjectsAndKeys:@"A1B2C3E4F5123",@"appID",studentInfo,@"student", nil];
        NSLog(@"The Student Object is %@:", studentObject);
        [self insertNewStudent:studentObject];
        NSLog(@"The Sons Array is %@:", sons);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        [_firstNameTextField resignFirstResponder];
        _firstNameTextField.text = nil;
        _lastNameTextField.text = nil;
        _dateOfBirthField.text = nil;
        _currentSchoolTextField.text = nil;
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

#pragma mark - Take Photo Methods

- (IBAction)takePhotoAction:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;	
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;	
	[self presentModalViewController:picker animated:YES];	

}


// Recives the message when the controller has finised
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
	// Remove View From Controller 
	[picker dismissModalViewControllerAnimated:YES];
	// Establece la imagen tomada en el objeto UIImageView
	_studentImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

     
#pragma mark - Facebook Data Request


- (void)requestFacebookData {
    [[Facebook shared] requestWithGraphPath:@"me?fields=id,email,name,picture,birthday,location" andDelegate:self];
    
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
    NSDictionary * userData = [[NSDictionary alloc] initWithDictionary:result];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * tokenDeAcceso =[defaults objectForKey:kFBAccessTokenKey];
    [defaults setObject:userData forKey:@"facebookParentInfo"];
    [defaults synchronize];
    
    
    NSLog(@"La url del request es: %@", request.url);
    NSLog(@"FB el request result es: %@", userData);
    
    [self useDatosLogin:userData withToken:tokenDeAcceso];
    
}



- (IBAction)disconnectFromFB:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cleanFacebookData) 
                                                 name:@"FBDidLogout" 
                                               object:nil];
    [[Facebook shared] logout];
}
- (void)cleanFacebookData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"facebookParentInfo"];
    [defaults synchronize];
    NSLog(@"En Logout los datos de usuario son: %@", [defaults objectForKey:@"facebookParentInfo"]);
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)backButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
