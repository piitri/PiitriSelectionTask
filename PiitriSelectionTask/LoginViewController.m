//
//  ViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "LoginViewController.h"
#import "Facebook+Singleton.h"

@interface LoginViewController ()

@property (nonatomic, strong) NSMutableData * receivedData;//instance variable to recieve the response of the API Call

@end

@implementation LoginViewController
@synthesize receivedData = _receivedData;
@synthesize textCreateAccount = _textCreateAccount;
@synthesize textWelcome = _textWelcome;
@synthesize loginFBButton = _loginFBButton;


- (id)init {
    if ((self = [super init])) {
        NSLog(@"viewController.m started correctly");
    }
    return self;
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
    NSLog(@"Before Calling Facebook Auth in Login");
    NSLog(@"The user Data when the Connect with Facebook Button was pressed is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookParentInfo"]);
    NSLog(@"and the Access Token is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:kFBAccessTokenKey]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"facebookParentInfo"] != nil) {
         NSLog(@"No hubo necesidad de llamar a Facebook Auth");
        [self presentParentPortal];
       
    }else{
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(requestFacebookData:) 
                                                     name:@"FBDidLogin" 
                                                   object:nil];
        
        [self autorizeWithFacebook];
        
         NSLog(@"The ***FBDidLogin*** Observer is SET");
    }
    
}

- (void)requestFacebookData:(NSNotification *) notification {
    NSLog(@"\n****** FBDidLogin was CALLED ******\n");
    
    NSLog(@"Inside the requestFacebookData Method in LoginViewController");
    NSLog(@"The user Data requestFacebookData is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookParentInfo"]);
    NSLog(@"and the Access Token is: %@", [[NSUserDefaults standardUserDefaults] objectForKey:kFBAccessTokenKey]);
    [self requestFacebookDataParent];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(sendParentInfo) 
                                                 name:@"FBParentInfoIsReady" 
                                               object:nil];
}


#pragma mark - Facebook Login Callback Function
- (void) autorizeWithFacebook{
    [[Facebook shared] authorize];
    NSLog(@"After Calling Facebook Auth in Login");
}

- (void)requestFacebookDataParent {
    NSLog(@"The Facebook Auth");
    [[Facebook shared] requestWithGraphPath:@"me?fields=id,email,name,picture,birthday,location" andDelegate:[Facebook shared]];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBDidLogin" 
                                                  object:nil];
}

- (void)uploadPhotoToFacebook:(NSMutableDictionary *)params{
    [[Facebook shared] requestWithGraphPath:@"me/photos"
                                  andParams:params
                              andHttpMethod:@"POST"
                                andDelegate:[Facebook shared]];
}

- (void)logoutFromFacebook{
    [[Facebook shared] logout];
}

#pragma mark - Send Info To API

- (void)sendParentInfo{
    
    NSLog(@"\n****** FBParentInfoIsReady was CALLED ******\n");
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBParentInfoIsReady" 
                                                  object:nil];
    
    //Send Parent Info to Model to form the URL Request to Save Parent Info in API
    // Access Token asignation
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [defaults stringForKey:kFBAccessTokenKey]; 
    
    //Safe userData to standardUserDefaults in key facebookParentInfo
    //Log to know the Data from Facebook
    NSDictionary * parentData = [defaults objectForKey:@"facebookParentInfo"];
    NSLog(@"The facebookParentInfo assigned to userData is: %@", parentData);

    NSMutableURLRequest * requestApiReturned = [self sendParentInfoToApi:parentData andToken:accessToken];

    
    //Call the URL Connection with the Builded Request Structure
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestApiReturned delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
        NSLog(@"The connection to Send Parent Info has STARTED! ");
        
        
    } else {
        // Inform the user that the connection failed.
        NSLog(@"The connection to Send Parent Info has FAILED!");
    }
                                                  
}

- (NSMutableURLRequest * )sendParentInfoToApi:(NSDictionary *)userData andToken:accessTokenKey{
    NSLog(@"Inside sendParentInfoToApi");
    
    //Post Node.js API
    //Get Location to form Request
    NSDictionary * locationDic = [[NSDictionary alloc]initWithDictionary:[userData objectForKey:@"location"]];
    NSString * locationStr = [locationDic objectForKey:@"name"];
    
    //Get Profile Picture to form Request
    NSString * strProfilePicLink = [NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&access_token=%@", accessTokenKey];
    
    //Create user Dictionary with email, location, name and picture_url
    NSDictionary * user = [[NSDictionary alloc] initWithObjectsAndKeys:[userData objectForKey:@"email"],@"email",locationStr,@"location",[userData objectForKey:@"name"],@"name", strProfilePicLink, @"picture_url", nil];
    
    //Create authStrategy Dicttionary with provider and token
    NSDictionary * authStrategyDict = [[NSDictionary alloc] initWithObjectsAndKeys: @"Facebook", @"provider", accessTokenKey,@"token", nil];
    
    //Create JSON Request Body Dictionary with email, location, name and picture_url
    NSDictionary * jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"A1B2C3E4F5123",@"appID",user,@"user",authStrategyDict,@"authStrategy", nil];
    //[defaults setObject:jsonDict forKey:@"jsonParentInfo"];
    //[defaults synchronize];
    
    NSLog(@"The JSON Dictionary for the API request in viewController.m is: %@", jsonDict);
    
    //Parse the jsonDict to JSON data with native NSJSONSerialization and create a NSString
    NSError* error = nil;
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    NSString *jsonRequestAscii = [[NSString alloc] initWithData:jsonRequestData encoding:NSASCIIStringEncoding]; //Change from utf8 to ascii
    NSString *jsonRequestUtf8 = [[NSString alloc] initWithData:jsonRequestData encoding:NSUTF8StringEncoding];
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/login"];
    //
    //http://postbin.defensio.com/bfb029d
    
    //Create the URL Request
    NSMutableURLRequest * requestApi = [NSMutableURLRequest requestWithURL:urlRequestLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSLog(@"The jsonRequest in ASCII is: %@ and the longitude is: %i",jsonRequestAscii,[jsonRequestAscii length]);
    
    //Buid the Request Data
    NSData  * requestData = [NSData dataWithBytes:[jsonRequestUtf8 UTF8String] length:[jsonRequestAscii length]];
    [requestApi setHTTPMethod:@"POST"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestApi setHTTPBody:requestData];
    
    return requestApi;
    
}



#pragma mark - Call parent Portal

- (void) presentParentPortal{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController*  ParentPortalVC = [storyboard instantiateViewControllerWithIdentifier:@"ParentPortal"];
    
    [ParentPortalVC setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self performSegueWithIdentifier:@"fromLoginToParentPortal" sender:self];
    
}

#pragma mark - NSURLResponse Delegate Metods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    // receivedData is an instance variable declared on top of this class.
    
    [self.receivedData setLength:0];
    /*NSString * responseStatusCodeStr = [[NSString alloc] initWith:(NSURLResponse *)response];*/
    NSLog(@"The URL Response is :%@", response.URL);
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
    NSLog(@"Succeeded! Received %d bytes of data in Login ",[self.receivedData length]);
    
    NSString * requestMethod = [[NSString alloc] initWithString:connection.originalRequest.HTTPMethod];
    NSLog(@"And the request Method in Login was %@",requestMethod);
    
    if ([connection.originalRequest.HTTPMethod isEqualToString:@"POST"]) {
        
        NSURL * testURL = connection.originalRequest.URL.standardizedURL;
        NSString * originalRequestUrlStr = [[NSString alloc] initWithContentsOfURL:testURL encoding:NSUTF8StringEncoding error:&error];
       
        if (error != nil) {
            NSLog(@"We have the following error when creating the originalRequestUrlStr in Login: %@", error);
        }
        NSLog(@"The Original Request URL is%@",originalRequestUrlStr);
        NSLog(@"The Original Direct Request URL is: %@",connection.originalRequest.URL);
        NSLog(@"The Test Request URL is: %@",testURL);
        
        NSArray * receivedDataDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
        
        if (errorJson != nil) {
            NSLog(@"We have the following error when creating the JSON object in Login: %@", errorJson);
        }
        
        NSMutableArray *receivedDataMutableArray =[[NSMutableArray alloc] initWithArray:receivedDataDict];
        
        //Print the received Data
        NSLog(@"The response to the Parent Info API request in Login as MutableArray is: %@", receivedDataMutableArray);
        //Print the received Cookie
        NSHTTPCookie * galletas = (NSHTTPCookie *)[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/login"]];
        NSLog(@"The cookies are: %@", galletas);
        
        //NSLog(@"The size of the sons array in LoginViewController is: %@", receivedDataMutableArray.count);
        
        [[NSUserDefaults standardUserDefaults] setObject:receivedDataMutableArray forKey:@"sons"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self presentParentPortal];
        
    }
}


@end
