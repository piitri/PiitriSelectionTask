//
//  ViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 20/07/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "ViewController.h"
#import "Facebook+Singleton.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize cajaTextoLogin;
@synthesize textCreateAccount;
@synthesize textWelcome;
@synthesize loginFBButton;

int numero = 1;

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
    UIColor *backgroundLogin = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"log-in-bg.png"]];
    self.view.backgroundColor = backgroundLogin;
    /*self.textCreateAccount.font = [UIFont boldSystemFontOfSize:48];*/
    self.textCreateAccount.font = [UIFont fontWithName:@"Open Sans"  size:48];
    self.textWelcome.font = [UIFont fontWithName:@"Open Sans"  size:16];
    
}

- (void)viewDidUnload
{
    [self setLoginFBButton:nil];
    [self setCajaTextoLogin:nil];
    [self setTextCreateAccount:nil];
    [self setTextWelcome:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"FBDidLogin" 
                                                  object:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)connectWithFB:(id)sender {
    //Code to Log in with Facebook
    NSMutableString * textoDeCaja = [[NSMutableString alloc] initWithString:@"Let's Login With Facebook "];
    NSString * numeroString = [NSString stringWithFormat:@"%i", numero];
    [textoDeCaja appendString:numeroString];
    self.cajaTextoLogin.text = textoDeCaja;
    numero=numero+1;
    NSLog(@"Antes de llamar a Facebook Auth");
    NSLog(@"Los datos de usuario son: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosdeUsuario"]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DatosdeUsuario"] != nil) {
        [self presentParentPortal];
    }
    [[Facebook shared] authorize];
    NSLog(@"Despues de llamar a Facebook Auth");
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(requestFacebookData:) 
                                                 name:@"FBDidLogin" 
                                               object:nil];
    /*[self requestFacebookData:];*/
    
}

- (void)requestFacebookData:(NSNotification *) notification {
    NSLog(@"Despues de llamar a Facebook Auth entre la notificacion");
    /*while (YES) {
        if ([[notification name] isEqualToString:@"TestNotification"]){
            break;
        }
    }*/
    
    [[Facebook shared] requestWithGraphPath:@"me?fields=id,email,name,picture,birthday,location" andDelegate:self];
    
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    //Log to know the Data from Facebook
    NSLog(@"FB request OK");
    NSDictionary * userData = [[NSDictionary alloc] initWithDictionary:result];
    NSLog(@"La url del request es: %@", request.url);
    NSLog(@"FB el request result en viewController.m es: %@", userData);
    // Access Token an Expiration Day asignation
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * accessTokenClave = [defaults objectForKey:kFBAccessTokenKey]; 
    NSDate * datoExpirationDate = [defaults objectForKey:kFBExpirationDateKey];
    //Show Facebook Access Token
    NSMutableString * textoDeCaja = [[NSMutableString alloc] init];
    [textoDeCaja appendString:@"The AccessToken is: \n"];
    [textoDeCaja appendString:accessTokenClave];
    //Show Facebook Expiration Date
    [textoDeCaja appendString:@" \nand the Expiration Date is : "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString * textoExpirationDate = [dateFormatter stringFromDate:datoExpirationDate];
    [textoDeCaja appendString:textoExpirationDate];
    
    self.cajaTextoLogin.text = textoDeCaja;
    
    //Safe userData to standardUserDefaults in key DatosdeUsuario
    [defaults setObject:userData forKey:@"DatosdeUsuario"];
    [defaults synchronize];
    
    
    
    //Post Node.js API
    //Get Location to form Request
    NSDictionary * locationDic = [[NSDictionary alloc]initWithDictionary:[userData objectForKey:@"location"]];
    NSString * locationStr = [locationDic objectForKey:@"name"];
    
    //Get Profile Picture to form Request
    NSURL * urlProfilePic = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&access_token=%@", accessTokenClave]];
    NSData * dataProfilePic = [NSData dataWithContentsOfURL:urlProfilePic];
    UIImage * profilePicLarge = [[UIImage alloc] initWithData:dataProfilePic];
    NSString *strProfilePic = [[NSString alloc] initWithContentsOfURL:urlProfilePic encoding:NSUTF8StringEncoding error:nil];
    
    //Create user Dictionary with email, location, name and picture_url
    NSDictionary * user = [[NSDictionary alloc] initWithObjectsAndKeys:[userData objectForKey:@"email"],@"email",locationStr,@"location",[userData objectForKey:@"name"],@"name", strProfilePic, @"picture_url", nil];
    
    //Create JSON Request Body Dictionary with email, location, name and picture_url
    NSDictionary * jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys: @"Facebook", @"OAuthProvider", accessTokenClave,@"AccessToken", @"A1B2C3E4F5123",@"AppID",user,@"user", nil];
    
    NSLog(@"El diccionario JSON para el request al API en viewController.m es: %@", jsonDict);
    
    //Parse the jsonDict to JSON data with native NSJSONSerialization and create a NSString
    NSError* error = nil;
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    NSString *jsonRequest = [[NSString alloc] initWithData:jsonRequestData encoding:NSUTF8StringEncoding];    
    NSLog(@"El string JSON para el request al API en viewController.m es: %@", jsonRequest);
    
    //Create URL Request
    NSURL *urlRequestLink = [NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/login"];
    
    NSMutableURLRequest * requestApi = [NSMutableURLRequest requestWithURL:urlRequestLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData  * requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    [requestApi setHTTPMethod:@"POST"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestApi setHTTPBody:requestData];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:requestApi delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSMutableData * responseData = [NSMutableData data];
        NSDictionary * responseDataDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        NSLog(@"La respuesta a el request del API es: %@", responseData);
        
        [self presentParentPortal];
    } else {
        // Inform the user that the connection failed.
        NSLog(@"La respuesta a el request del API es ERRONEA");
    }
    
}


- (void) presentParentPortal{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController*  ParentPortalVC = [storyboard instantiateViewControllerWithIdentifier:@"ParentPortal"];
    
    [ParentPortalVC setModalPresentationStyle:UIModalPresentationFullScreen];
    
    /*[self presentModalViewController:ParentPortalVC animated:YES];*/
    [self performSegueWithIdentifier:@"fromLoginToParentPortal" sender:self];
    
}


@end
