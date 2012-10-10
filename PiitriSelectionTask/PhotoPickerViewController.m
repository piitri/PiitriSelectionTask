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
@synthesize cameraButton = _cameraButton;
@synthesize galleryButton = _galleryButton;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCameraButton:nil];
        [self setGalleryButton:nil];
    }
    return self;
}

/*-(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 4.0f;
    //layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}*/

- (void)viewDidLoad
{
    //[self addGradient:self.cameraButton];
    //[self addGradient:self.galleryButton];
    [self.cameraButton useWhiteActionSheetStyle];
    [self.galleryButton useWhiteActionSheetStyle];
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
