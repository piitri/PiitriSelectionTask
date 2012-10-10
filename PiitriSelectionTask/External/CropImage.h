//
//  CropImage.h
//  Piitri
//
//  Created by David Cespedes on 8/10/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CropImage : NSObject
//Image Crop Method
- (UIImage*)image:(UIImage *)sourceImage ByScalingAndCroppingForSize:(CGSize)targetSize;
@end
