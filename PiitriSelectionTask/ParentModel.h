//
//  ParentModel.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 26/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentModel : NSObject{
    NSMutableArray * sons;
}

@property (nonatomic, strong) NSMutableArray * sons;

- (void)insertNewStudentInSons:(NSDictionary *)student;

//Student Methods
- (void)retrieveApiSavedStudents:(NSArray *)sonsFromApi;

@end
