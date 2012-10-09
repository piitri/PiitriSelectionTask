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

//sons Initializer
- (NSMutableArray *)sons
{
    if (!_sons) {
        _sons = [[NSMutableArray alloc] init];
    }
    return _sons;
}

//receivedData Initializer
- (NSMutableData *)receivedData
{
    if (!_receivedData) {
        _receivedData = [[NSMutableData alloc] init];
    }
    return _receivedData;
}

- (void)insertNewStudentInSons:(NSDictionary *)student
{
    [self.sons insertObject:student atIndex:0];
}

#pragma mark - Student Methods

- (void) retrieveApiSavedStudents:(NSArray *)sonsFromApi{
    //Assign sons key from NSUserDefaults to sons local Mutable Array
    self.sons = [[NSMutableArray alloc] initWithArray:sonsFromApi];
    //[defaults arrayForKey:@"sons"]
    NSLog(@"Sons were drawn in the Table");
    
    NSLog(@"The sons array in the Parent Portal has %i objects and they are: %@", self.sons.count, self.sons);
}

@end
