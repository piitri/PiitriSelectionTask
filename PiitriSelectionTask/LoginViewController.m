//
//  ViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "LoginViewController.h"
#import "Facebook+Singleton.h"
#import "ParentModel.h"
#import "APICommunication.h"

@interface LoginViewController ()

//instance variable to recieve the response of the API Call

@property (nonatomic, strong) ParentModel * parentUserLoginModel;
@property (nonatomic, strong) APICommunication * apiLoginCommunication;

@end

@implementation LoginViewController

@synthesize parentUserLoginModel = _parentUserLoginModel;
@synthesize apiLoginCommunication = _apiLoginCommunication;
@synthesize textCreateAccount = _textCreateAccount;
@synthesize textWelcome = _textWelcome;
@synthesize loginFBButton = _loginFBButton;


- (id)init {
    if ((self = [super init])) {
        NSLog(@"viewController.m started correctly");
    }
    return self;
}

- (ParentModel *) parentUserLoginModel
{
    if (!_parentUserLoginModel) {
        _parentUserLoginModel = [[ParentModel alloc] init];
    }
    return _parentUserLoginModel;
}

- (APICommunication *) apiLoginCommunication
{
    if (!_apiLoginCommunication) {
        _apiLoginCommunication = [[APICommunication alloc] init];
    }
    return _apiLoginCommunication;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIColor *backgroundLogin = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"log-in-bg-with-mask.png"]];
    self.view.backgroundColor = backgroundLogin;
    self.textCreateAccount.font = [UIFont fontWithName:@"MetaPlus"  size:30];
    self.textWelcome.font = [UIFont fontWithName:@"Open Sans"  size:16];
    
    
}

- (void)viewDidUnload
{
    [self setLoginFBButton:nil];
    [self setTextCreateAccount:nil];
    [self setTextWelcome:nil];
    [self setLoginActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBDidLogin" 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBParentInfoIsReady" 
                                                  object:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Connect With Facebook Button

- (IBAction)connectWithFB:(id)sender {
    //Code to Log in with Facebook
    {
    NSLog(@"Before Calling Facebook Auth in Login");
    NSLog(@"The user Data when the Connect with Facebook Button was pressed is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookParentInfo"]);
    NSLog(@"and the Access Token is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:kFBAccessTokenKey]);
    }
    //Verify if it is already loged with Facebook
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"facebookParentInfo"] != nil) {
         NSLog(@"There was no need to call Facebook Auth");
        [self presentParentPortal];
       
    }else{
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(requestFacebookData:) 
                                                     name:@"FBDidLogin" 
                                                   object:nil];
        //Facebook+Singleton Authorize
        [[Facebook shared] authorize];
        {
        NSLog(@"After Calling Facebook Auth in Login");
        NSLog(@"The ***FBDidLogin*** Observer is SET");
        }
    }
    
}


- (void)requestFacebookData:(NSNotification *) notification {
    {
    NSLog(@"\n****** FBDidLogin was CALLED ******\n");
    NSLog(@"Inside the requestFacebookData Method in LoginViewController");
    NSLog(@"The user Data requestFacebookData is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookParentInfo"]);
    NSLog(@"and the Access Token is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:kFBAccessTokenKey]);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FBDidLogin"
                                                  object:nil];
    //Request Parent info from Facebook
    //Facebook+Singleton requestWithGraphPath
    [[Facebook shared] requestWithGraphPath:@"me?fields=id,email,name,picture,birthday,location" andDelegate:[Facebook shared]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(sendParentInfo) 
                                                 name:@"FBParentInfoIsReady" 
                                               object:nil];
    
}

#pragma mark - Send Info To API

- (void)sendParentInfo{
    //Should Save ParentInfo into the Parentmodel here???
    NSLog(@"\n****** FBParentInfoIsReady was CALLED ******\n");
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBParentInfoIsReady"
                                                  object:nil];
    
    [self.loginActivityIndicator startAnimating];
    [self.loginFBButton setEnabled:NO];

    

    //APICommunication sendParentInfoToApi Method
    
    NSString * apiConnectionResult = [self.apiLoginCommunication sendParentInfoToApi];
    NSLog(@"In Login %@",apiConnectionResult);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveRecivedSonsFromApi:)
                                                 name:@"APISonsReceived"
                                               object:nil];
                                                  
}

#pragma mark - Call parent Portal

- (void) saveRecivedSonsFromApi: (NSNotification *) aNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"APISonsReceived"
                                                  object:nil];
    
    //Save received Object from API to Model
    NSDictionary * sons= [aNotification.userInfo objectForKey:@"object"];
    [[NSUserDefaults standardUserDefaults] setObject:sons forKey:@"sons"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.loginActivityIndicator stopAnimating];
    [self.loginFBButton setEnabled:YES];
    
    [self presentParentPortal];
}

- (void) presentParentPortal{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController*  ParentPortalVC = [storyboard instantiateViewControllerWithIdentifier:@"ParentPortal"];
    
    [ParentPortalVC setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self performSegueWithIdentifier:@"fromLoginToParentPortal" sender:self];
    
}

@end
