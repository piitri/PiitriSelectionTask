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
//Student Methods
- (void)retrieveApiSavedStudents:(NSArray *)sonsFromApi;
- (void)insertNewStudentInSons:(NSDictionary *)student;

//Facebook Methods
- (void)autorizeWithFacebook;
- (void)requestFacebookDataParent;
- (void)uploadPhotoToFacebook:(NSMutableDictionary *)params;
- (void)logoutFromFacebook;

//Image Crop Method
- (UIImage*)image:(UIImage *)sourceImage ByScalingAndCroppingForSize:(CGSize)targetSize;

//API Methods
- (NSMutableURLRequest * )sendStudentToApi:(NSDictionary *)user;
- (NSMutableURLRequest * )deleteStudentFromApi:(NSString *)userId 
                 forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSMutableURLRequest * )logoutFromApi;
@end
