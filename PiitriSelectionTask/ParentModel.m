//
//  ParentModel.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 26/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import "ParentModel.h"
#import "Facebook+Singleton.h"

@interface ParentModel()

@property (nonatomic, strong) NSMutableData * receivedData;//instance variable to recieve the response of the API Call

@end

@implementation ParentModel

@synthesize sons = _sons;
@synthesize receivedData = _receivedData;

//sons GETTER
- (NSMutableArray *)sons
{
    if (!_sons) {
        _sons = [[NSMutableArray alloc] init];
    }
    return _sons;
}

//receivedData Getter
- (NSMutableData *)receivedData
{
    if (!_receivedData) {
        _receivedData = [[NSMutableData alloc] init];
    }
    return _receivedData;
}

- (void) retrieveApiSavedStudents:(NSArray *)sonsFromApi{
    //Assign sons key from NSUserDefaults to sons local Mutable Array
    self.sons = [[NSMutableArray alloc] initWithArray:sonsFromApi];
    //[defaults arrayForKey:@"sons"]
    NSLog(@"Sons were drawn in the Table");
    
    NSLog(@"The sons array in the Parent Portal has %i objects and they are: %@", self.sons.count, self.sons);
}

- (void)insertNewStudentInSons:(NSDictionary *)student
{
    [self.sons insertObject:student atIndex:0];
}
#pragma mark - Facebook Methods

- (void) autorizeWithFacebook{
    [[Facebook shared] authorize];
    NSLog(@"After Calling Facebook Auth in Login");
}

- (void)requestFacebookDataParent {
    NSLog(@"The Facebook Auth");
    [[Facebook shared] requestWithGraphPath:@"me?fields=id,email,name,picture,birthday,location" 
                                andDelegate:[Facebook shared]];
    
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

#pragma mark - Crop Image

- (UIImage*)image:(UIImage *)sourceImage ByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Create, Delete and Logout Student from API



- (NSMutableURLRequest * )sendStudentToApi:(NSDictionary *)user{
    //Post Student info to Node.js API
    
    //Create user Dictionary with email, location, name and picture_url
    //NSDictionary * user = [[NSDictionary alloc] initWithObjectsAndKeys:sons,@"sons", nil];
    
    
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
    
    NSLog(@"The jsonRequest in ASCII is: %@ and the longitude is: %i",jsonRequestAscii,[jsonRequestAscii length]);
    [requestApi setHTTPMethod:@"POST"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestApi setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //Buid the Request Data
    NSData  * requestData = [NSData dataWithBytes:[jsonRequestUtf8 UTF8String] length:[jsonRequestAscii length]];
    [requestApi setHTTPBody:requestData];
    
    
    return requestApi;
}

- (NSMutableURLRequest * )deleteStudentFromApi:(NSString *)userId forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://piitri-api.herokuapp.com/v1/student/%@",userId]];
    
    //Create the URL Request
    NSMutableURLRequest * requestApiDelete = [NSMutableURLRequest requestWithURL:urlRequestLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestApiDelete setHTTPMethod:@"DELETE"];
    
    return requestApiDelete;    
}

- (NSMutableURLRequest * )logoutFromApi{
    
    //Create the URL
    NSURL *urlRequestLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://piitri-api.herokuapp.com/v1/logout"]];
    
    //Create the URL Request
    NSMutableURLRequest * requestApiLogout = [NSMutableURLRequest requestWithURL:urlRequestLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [requestApiLogout setHTTPMethod:@"GET"];
    
    return requestApiLogout;
    
}


@end
