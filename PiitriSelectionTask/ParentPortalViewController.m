//
//  ParentPortalViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "ParentPortalViewController.h"
#import "Facebook+Singleton.h"

@interface ParentPortalViewController ()

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
@synthesize accountsButton = _accountsButton;
@synthesize addNewStudentButton = _addNewStudentButton;
@synthesize myLessonsButton = _myLessonsButton;
@synthesize storeButton = _storeButton;

/*Para hacer el logout
 - (id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(disconnectFromFB) 
                                                     name:@"FBDidLogout" 
                                                   object:nil];
    }
    return self;
}*/

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
    
    //Sidebar Buttons Fonts
    
    self.accountsButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:20];
    self.myLessonsButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:20];
    self.storeButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:20];
    
    
    
    self.editProfileButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];
    self.buyCoinsButton.titleLabel.font = [UIFont fontWithName:@"MetaPlus" size:17];

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"DatosdeUsuario"]) {
        [self requestFacebookData];
    }else {
        [self useDatosLogin:[defaults objectForKey:@"DatosdeUsuario"] withToken:(NSString *) [defaults objectForKey:kFBAccessTokenKey]];
    }
    
    
    
}

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
    [defaults setObject:userData forKey:@"DatosdeUsuario"];
    [defaults synchronize];
    
    
    NSLog(@"La url del request es: %@", request.url);
    NSLog(@"FB el request result es: %@", userData);
    
    [self useDatosLogin:userData withToken:tokenDeAcceso];
    
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
    [self setAccountsButton:nil];
    [self setAddNewStudentButton:nil];
    [self setMyLessonsButton:nil];
    [self setStoreButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
    [defaults removeObjectForKey:@"DatosdeUsuario"];
    [defaults synchronize];
    NSLog(@"En Logout los datos de usuario son: %@", [defaults objectForKey:@"DatosdeUsuario"]);
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)backButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
