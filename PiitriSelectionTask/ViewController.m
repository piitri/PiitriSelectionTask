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
    NSLog(@"FB request OK");
    NSDictionary * userData = [[NSDictionary alloc] initWithDictionary:result];
    NSLog(@"La url del request es: %@", request.url);
    NSLog(@"FB el request result en viewController.m es: %@", userData);
    // Access Token an Expiration Day asignation
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * AccessTokenClave = [defaults objectForKey:kFBAccessTokenKey]; 
    NSDate * datoExpirationDate = [defaults objectForKey:kFBExpirationDateKey];
    
    NSMutableString * textoDeCaja = [[NSMutableString alloc] init];
    [textoDeCaja appendString:@"The AccessToken is: \n"];
    [textoDeCaja appendString:AccessTokenClave];
    [textoDeCaja appendString:@" \nand the Expiration Date is : "];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString * textoExpirationDate = [dateFormatter stringFromDate:datoExpirationDate];

    [textoDeCaja appendString:textoExpirationDate];
    
    [defaults setObject:userData forKey:@"DatosdeUsuario"];
    [defaults synchronize];
    
    self.cajaTextoLogin.text = textoDeCaja;
    
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController*  ParentPortalVC = [storyboard instantiateViewControllerWithIdentifier:@"ParentPortal"];
    [ParentPortalVC setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentModalViewController:ParentPortalVC animated:YES];    
    
}


@end
