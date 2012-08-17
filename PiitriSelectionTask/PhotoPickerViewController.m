//
//  PhotoPickerViewController.m
//  PiitriSelectionTask
//
//  Created by LSR Marketing Service on 16/08/12.
//  Copyright (c) 2012 Piitri. All rights reserved.
//

#import "PhotoPickerViewController.h"

@interface PhotoPickerViewController ()

@end

@implementation PhotoPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takePhoto:(UIButton *)sender {
    [self.delegate photoPickerViewController:self chosenPictureMethodStr:@"UIImagePickerControllerSourceTypeCamera"];
}

- (IBAction)chooseFromGallery:(UIButton *)sender {
    
    [self.delegate photoPickerViewController:self chosenPictureMethodStr:@"UIImagePickerControllerSourceTypePhotoLibrary"];
}
@end
