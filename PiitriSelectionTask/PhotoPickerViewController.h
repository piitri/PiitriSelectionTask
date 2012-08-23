//
//  PhotoPickerViewController.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 16/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"

@class PhotoPickerViewController;

@protocol PhotoPickerViewControllerDelegate
@optional
- (void) photoPickerViewController:(PhotoPickerViewController *)sender chosenPictureMethodStr:(NSString *) pictureMethodStr; 

@end


@interface PhotoPickerViewController : UIViewController
{
    GradientButton *cameraButton;
    GradientButton *galleryButton;
}

@property (nonatomic, weak) id <PhotoPickerViewControllerDelegate> delegate;
- (IBAction)takePhoto:(GradientButton *)sender;
- (IBAction)chooseFromGallery:(GradientButton *)sender;
@property (strong, nonatomic) IBOutlet GradientButton *cameraButton;
@property (strong, nonatomic) IBOutlet GradientButton *galleryButton;


@end
