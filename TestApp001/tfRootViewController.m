//
//  tfRootViewController.m
//  TestApp001
//
//  Created by 高橋 聖二 on 12/07/24.
//  Copyright (c) 2012年 trifeed inc. All rights reserved.
//

#import "tfRootViewController.h"
#import "tfSecondViewController.h"

@interface tfRootViewController ()

@end

@implementation tfRootViewController
@synthesize viewMap;

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
    // Do any additional setup after loading the view from its nib.
    viewMap = [[MKMapView alloc] init];
}

- (void)viewDidUnload
{
    [self setViewMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnTapAction:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"あーあ" message:@"タップしてやんの" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
    
    NSLog(@"ボタンがタップされました");
}

- (IBAction)btnWatchNext:(UIButton *)sender {
    tfSecondViewController *second = [[tfSecondViewController alloc] initWithNibName:@"tfSecondViewController" bundle:nil];
    [self presentViewController:second animated:YES completion:nil];
}

// 「キャンセル(Cancel)」をタップしたユーザへの応答.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissModalViewControllerAnimated: YES];
    //[picker release];
}

// 新規にキャプチャした写真やムービーを受理したユーザへの応答
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    // 静止画像のキャプチャを処理する
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        // （オリジナルまたは編集後の）新規画像を「カメラロール(Camera Roll)」に保存する
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    }
    
    [picker dismissModalViewControllerAnimated: YES];
    //[picker release];
}

- (BOOL)openCamera:(UIViewController*) controller usingDelegate: (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate {

    UIImagePickerController *camera = [[UIImagePickerController alloc] init ];
    camera.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.allowsEditing = NO;
    camera.delegate = delegate;
    
    [controller presentModalViewController:camera animated:YES];
    return YES;
}

- (IBAction)startCamera:(UIButton *)sender {

    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    NSString *s = [[NSString alloc] init];
    s = @"つかえないお";
    if(cameraAvailable)
    {
        s = @"つかえるお";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"カメラの状態" message:s delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    if(!cameraAvailable){
        return;
    }
 
    [self openCamera:self usingDelegate:self];
}
@end
