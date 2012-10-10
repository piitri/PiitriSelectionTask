//
//  Facebook+Singleton.m
//
//  Created by Barry Murphy on 7/25/11.
//
//  If you use this software in your project, a credit for Barry Murphy
//  and a link to http://barrycenter.com would be appreciated.
//
//  --------------------------------
//  Simplified BSD License (FreeBSD)
//  --------------------------------
//
//  Copyright 2011 Barry Murphy. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of
//     conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list
//     of conditions and the following disclaimer in the documentation and/or other materials
//     provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY BARRY MURPHY "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BARRY MURPHY OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of Barry Murphy.
//

#import "Facebook+Singleton.h"


@implementation Facebook (Singleton)

- (id)init {
    if ((self = [self initWithAppId:@"364390736967265" andDelegate:self])) {
        [self authorize];
        NSLog(@"Facebook singleton initializated");
    }
    return self;
}

- (void)authorize {
    NSLog(@"authorize *** called in Facebook+Singleton.m");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kFBAccessTokenKey] && [defaults objectForKey:kFBExpirationDateKey]) {
        self.accessToken = [defaults objectForKey:kFBAccessTokenKey];
        self.expirationDate = [defaults objectForKey:kFBExpirationDateKey];
    }
    
    if (![self isSessionValid]) {
        //
        // Only ONE of the following authorize methods should be uncommented.
        //
        
        // This is the method Facebook wants users to use. 
        // It will leave your app and authoize through the Facebook app or Safari.
        NSLog(@"Session Invalid so let's Authorize with permissions");
        NSArray *permissions =  [NSArray arrayWithObjects:@"email", @"user_photos", @"user_about_me",@"user_birthday",@"publish_actions", nil];
        [self authorize:permissions/* localAppId:nil*/];
        
        // This will authorize from within your app.
        // It will not leave your app nor take advantage of the user logged in elsewhere.
        //[self authorizeInApp:nil localAppId:nil];
        
        // This will only leave your app if the user has the Facebook app.
        // Otherwise it will stay within your app.
        //[self authorizeWithFacebookApp:nil localAppId:nil];
    }
}


#pragma mark - FBSessionDelegate Methods

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self accessToken] forKey:kFBAccessTokenKey];
    [defaults setObject:[self expirationDate] forKey:kFBExpirationDateKey];
    [defaults synchronize];
    NSLog(@"In the Login the Token is %@ and the expiration date is %@", [self accessToken], [self expirationDate]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogin" object:self];
    
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginCancelled" object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBLoginFailed" object:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidNotLogin" object:self];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kFBAccessTokenKey];
    [defaults removeObjectForKey:kFBExpirationDateKey];
    [defaults removeObjectForKey:@"facebookParentInfo"];
    //[defaults removeObjectForKey:@"jsonParentInfo"];
    [defaults removeObjectForKey:@"sons"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidLogout" object:self];
    NSLog(@"In the Logout the Token is %@ and the expiration date is %@", [self accessToken], [self expirationDate]);
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    
}
- (void)fbSessionInvalidated{
    
}
/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"FB request in Facebook+Singleton.m request:didLoad: is OK");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * tokenDeAcceso =[defaults stringForKey:kFBAccessTokenKey];
    
    if([request.url rangeOfString:@"me?fields=id,email"].location != NSNotFound) {
        NSDictionary * userData = [[NSDictionary alloc] initWithDictionary:result];
        [defaults setObject:userData forKey:@"facebookParentInfo"];
        [defaults synchronize];
        NSLog(@"The request url in Facebook+Singleton.m after calling me?fields=id,email,name,picture,birthday,location is: %@", request.url);
        NSLog(@"FB The request result in Facebook+Singleton.m sent to facebookParentInfo is: %@", userData);
        
        NSLog(@"FB Parent Info in Facebook+Singleton.m is Ready");
        NSLog(@"and the ***FBParentInfoIsReady*** is SET");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBParentInfoIsReady" object:self];
        
        
    }else if ([request.url rangeOfString:@"me/photos"].location != NSNotFound) {
        NSLog(@"Before assigning the Photo Result to a Dictionary");
        NSDictionary * photoResultDict = [[NSDictionary alloc] initWithDictionary:result];
        NSLog(@"After assigning the Photo Result to a Dictionary");
        NSLog(@"The result in Facebook+Singleton.m  calling Photo Upload is: %@", photoResultDict);
        NSLog(@"and the url in calling Photo Upload is: %@", request.url);
        //Save the Facebook Photo ID
        //Next line is commented because it was generating a Warning
        //NSString *photoIdStr = [[NSString alloc] initWithFormat:[photoResultDict objectForKey:@"id"]];
        NSString *photoIdStr = [photoResultDict objectForKey:@"id"];
        // Save the Uploaded Student picture URL.
        NSString *urlStr = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=thumbnail&access_token=%@",photoIdStr, tokenDeAcceso];
        [defaults setObject:urlStr forKey:@"studentImageUrlStr"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FBDidUploadPhoto" object:self];
    }
} 

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"FB error in Facebook+Singleton.m is: %@", [error localizedDescription]);
}


#pragma mark - Singleton Methods

static Facebook *shared = nil;

+ (Facebook *)shared {
	@synchronized(self) {
		if(shared == nil)
			shared = [[self alloc] init];
	}
	return shared;
}

@end
