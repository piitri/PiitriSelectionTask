//
//  PhotoPickerViewController.h
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 16/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPickerViewController;

@protocol PhotoPickerViewControllerDelegate
@optional
- (void) photoPickerViewController:(PhotoPickerViewController *)sender chosenPictureMethodStr:(NSString *) pictureMethodStr; 

@end


@interface PhotoPickerViewController : UIViewController
@property (nonatomic, weak) id <PhotoPickerViewControllerDelegate> delegate;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)chooseFromGallery:(UIButton *)sender;


@end
