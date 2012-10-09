//
//  APICommunication.h
//  Piitri
//
//  Created by David Cespedes on 5/10/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APICommunication : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData * receivedData;
}

@property (nonatomic, strong) NSMutableData * receivedData;

// API Methods
- (NSString * )logoutFromApi;

// Parent API Methods
- (NSString * )sendParentInfoToApi;

// Student API Methods
// Send to API
- (NSString * )sendStudentToApi:(NSDictionary *)user;
- (NSString * )deleteStudentFromApi:(NSString *)userId
                             forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
