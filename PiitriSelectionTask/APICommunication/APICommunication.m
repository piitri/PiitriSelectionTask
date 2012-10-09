//
//  APICommunication.m
//  Piitri
//
//  Created by David Cespedes on 5/10/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import "APICommunication.h"
#import "Facebook+Singleton.h"

@implementation APICommunication

@synthesize receivedData=_receivedData;

#pragma mark - API Methods

- (NSString * )logoutFromApi{
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://piitri-api.herokuapp.com/v1/logout"]];
    
    //Create the URL Request
    NSMutableURLRequest * requestApiLogout = [NSMutableURLRequest requestWithURL:urlRequestLink
                                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                 timeoutInterval:60.0];
    
    [requestApiLogout setHTTPMethod:@"GET"];
    
    return [self createConection:@"Logout" WithRequest:requestApiLogout];
    
    
}

#pragma mark - Parent API Methods

- (NSString * )sendParentInfoToApi{
    //Should Save ParentInfo into the Parentmodel here???
    
    //Send Parent Info to Model to form the URL Request to Save Parent Info in API
    // Access Token asignation
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [defaults stringForKey:kFBAccessTokenKey];
    
    //Safe userData to standardUserDefaults in key facebookParentInfo
    //Log to know the Data from Facebook
    NSDictionary * parentData = [defaults objectForKey:@"facebookParentInfo"];
    NSLog(@"The facebookParentInfo assigned to userData is: %@", parentData);
    
    
    
    NSMutableURLRequest * requestApiReturned = [self createURLRequestWithParentData:parentData andToken:accessToken];
    
    return [self createConection:@"Send Parent Info" WithRequest:requestApiReturned];

}

#pragma mark - Student API Methods
- (NSString * )sendStudentToApi:(NSDictionary *)user{
    //Post Student info to Node.js API
    
    //Parse the jsonDict to JSON data with native NSJSONSerialization and create a NSString
    NSError* error = nil;
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:user options:kNilOptions error:&error];
    NSString *jsonRequestAscii = [[NSString alloc] initWithData:jsonRequestData encoding:NSASCIIStringEncoding]; //cambié de utf8 a ascii
    NSString *jsonRequestUtf8 = [[NSString alloc] initWithData:jsonRequestData encoding:NSUTF8StringEncoding];
    NSLog(@"The JSON string for the request to the API in ParentPortalViewController.m is: %@", jsonRequestAscii);
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/student"];
    
    //Create the URL Request
    NSMutableURLRequest * requestApi = [NSMutableURLRequest requestWithURL:urlRequestLink
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
    
    NSLog(@"The jsonRequest in ASCII is: %@ and the longitude is: %i",jsonRequestAscii,[jsonRequestAscii length]);
    
    //Buid the Request Data
    NSData  * requestData = [NSData dataWithBytes:[jsonRequestUtf8 UTF8String] length:[jsonRequestAscii length]];
    [requestApi setHTTPMethod:@"POST"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestApi setHTTPBody:requestData];
    
    return [self createConection:@"Add Student" WithRequest:requestApi];
}

- (NSString * )deleteStudentFromApi:(NSString *)userId forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://piitri-api.herokuapp.com/v1/student/%@",userId]];
    
    //Create the URL Request
    NSMutableURLRequest * requestApiDelete = [NSMutableURLRequest requestWithURL:urlRequestLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestApiDelete setHTTPMethod:@"DELETE"];
    
    return [self createConection:@"Delete Student" WithRequest:requestApiDelete];
}

#pragma mark - Auxliliary Methods

- (NSMutableURLRequest * )createURLRequestWithParentData:(NSDictionary *)userData andToken:accessTokenKey{
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

- (NSString *)createConection:(NSString *)connectionType WithRequest:(NSMutableURLRequest *) theURLRequest{
    //Call the URL Connection with the Builded Request Structure
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theURLRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
        NSString * stringSuccessForConnectionLog = [NSString stringWithFormat:@"RETURN The connection %@ has STARTED!", connectionType];
        NSLog(@"%@", stringSuccessForConnectionLog);
        return stringSuccessForConnectionLog;
        
        
    } else {
        // Inform the user that the connection failed.
        NSString * stringFailedForConnectionLog = [NSString stringWithFormat:@"RETURN The connection %@ has FAILED!", connectionType];
        NSLog(@"%@", stringFailedForConnectionLog);
        return stringFailedForConnectionLog;
    }
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response

{
    // receivedData is an instance variable declared on top of this class.
    
    [self.receivedData setLength:0];
    //NSString * responseStatusCodeStr = [[NSString alloc] initWith:(NSURLResponse *)response];
    NSLog(@"The URL Response is :%@", response.URL);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"Status code %d", [httpResponse statusCode]);
    
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data

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
    NSError* errorJson = nil;
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    NSString * requestMethod = [[NSString alloc] initWithString:connection.originalRequest.HTTPMethod];
    NSLog(@"And the request Method was %@",requestMethod);
    
    if ([connection.originalRequest.HTTPMethod isEqualToString:@"POST"]) {
        NSString * originalRequestUrlStr = [connection.originalRequest.URL absoluteString];
        NSLog(@"The Original Request URL is%@",originalRequestUrlStr);
        
        if ([originalRequestUrlStr rangeOfString:@"/v1/login"].location != NSNotFound) {
            
            NSArray * receivedDataDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
            
            if (errorJson != nil) {
                NSLog(@"We have the following error when creating the JSON object in Login: %@", errorJson);
            }
            
            //Print the received Data
            NSLog(@"The response to the Parent Info API request is: %@", receivedDataDict);
            //Print the received Cookie
            NSHTTPCookie * galletas = (NSHTTPCookie *)[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://piitri-api.herokuapp.com/v1/login"]];
            NSLog(@"The cookies are: %@", galletas);
            
            
            NSDictionary * sonsDictionary = @{ @"type" : @"sons",@"object" : receivedDataDict};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APISonsReceived"
                                                                object:self
                                                              userInfo:sonsDictionary];
            
        }else if ([originalRequestUrlStr rangeOfString:@"/v1/student"].location != NSNotFound){
            NSDictionary * receivedDataDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
            
            if (errorJson != nil) {
                NSLog(@"We have the following error when creating the JSON object in Add Student: %@", errorJson);
            }
            //Print the received Data
            NSLog(@"The response to the Add Student API request is: %@", receivedDataDict);
            
            NSDictionary * studentDictionary = @{ @"type" : @"student",@"object" : receivedDataDict};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APIStudentAdded"
                                                                object:self
                                                              userInfo:studentDictionary]; 
        } 
    }else if ([connection.originalRequest.HTTPMethod isEqualToString:@"DELETE"]) {
        NSMutableArray * receivedDataArray = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&errorJson];
        if (errorJson != nil) {
            NSLog(@"We have the following error when creating the JSON object in DELETE: %@", errorJson);
        }
        //Print the received Data
        NSLog(@"The response to the DELETE Student API request is: %@", receivedDataArray);
        
        NSDictionary * remainingStudentsDictionary = @{ @"type" : @"remainingStudents",@"object" : receivedDataArray};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIStudentDeleted"
                                                            object:self
                                                          userInfo:remainingStudentsDictionary];
        
        
    }else if ([connection.originalRequest.HTTPMethod isEqualToString:@"GET"]) {
        NSLog(@"The Logout Connection is: %@", connection.currentRequest.allHTTPHeaderFields);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APILogout"
                                                            object:self
                                                          userInfo:nil];
    }
}


@end
