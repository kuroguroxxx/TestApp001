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

///////////////////////////////////////////////////////////////////
//  カメラ処理

// 「キャンセル(Cancel)」をタップしたユーザへの応答.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissModalViewControllerAnimated: YES];
    //[picker release];
}

// 新規にキャプチャした写真やムービーを受理したユーザへの応答
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    [picker dismissModalViewControllerAnimated: YES];

    [self startSignificantChangeUpdates];
    
    //NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //UIImage *originalImage, *editedImage, *imageToSave;
    // 静止画像のキャプチャを処理する
    UIImage *originalImage = (UIImage *) [info objectForKey:
                                          UIImagePickerControllerOriginalImage];
    
    
    // メタデータ表示（ログへ）
    NSMutableDictionary *metadata = (NSMutableDictionary *)[info objectForKey:UIImagePickerControllerMediaMetadata];  
    NSLog(@"%@", [metadata description]); 
    
    // （オリジナルまたは編集後の）新規画像を「カメラロール(Camera Roll)」に保存する
    //UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageToSavedPhotosAlbum:originalImage.CGImage
                             metadata:metadata
                      completionBlock:^(NSURL* url, NSError* error){
                          NSLog(@"Saved: %@<%@>", url, error);
                      }];
    //[lib release];        
    
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
    
    // カメラがこのデバイスで利用可能かを取得し、使用できなければメッセージを出し終了
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
    
    // カメラウインドウオープン
    [self openCamera:self usingDelegate:self];
}

///////////////////////////////////////////////////////////
// 位置情報系
- (void)startSignificantChangeUpdates
{
    // このオブジェクトにまだ位置情報マネージャがなければ、
    // 位置情報マネージャを作成する
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

// CLLocationManagerDelegateプロトコルのデリゲートメソッド
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // 比較的新しいイベントの場合は、節電のために更新をオフにする
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 1.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
    }
    NSLog(@"%@", newLocation);

    // それ以外の場合は、このイベントをスキップして次のイベントを処理する
}

- (void)writeLocationToImage: (UIImage*)image location:(CLLocation*) loc
{
    CGImageSourceRef img = CGImageSourceCreateWithData((__bridge CFDataRef)UIImageJPEGRepresentation(image, 0.7), NULL);
	NSMutableDictionary* exifDict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary* locDict = [[NSMutableDictionary alloc] init];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
	NSString* datetime = [dateFormatter stringFromDate:loc.timestamp];
	[exifDict setObject:datetime forKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
	[exifDict setObject:datetime forKey:(NSString*)kCGImagePropertyExifDateTimeDigitized];
	[locDict setObject:loc.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
	if (loc.coordinate.latitude <0.0){ 
		[locDict setObject:@"S" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
	}else{ 
		[locDict setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
	} 
	[locDict setObject:[NSNumber numberWithFloat:loc.coordinate.latitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
	if (loc.coordinate.longitude <0.0){ 
		[locDict setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
	}else{ 
		[locDict setObject:@"E" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
	} 
	[locDict setObject:[NSNumber numberWithFloat:loc.coordinate.longitude] forKey:(NSString*)kCGImagePropertyGPSLongitude];
	NSMutableData* imageData = [[NSMutableData alloc] init];
	CGImageDestinationRef dest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, CGImageSourceGetType(img), 1, NULL);
	CGImageDestinationAddImageFromSource(dest, img, 0, 
										 (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
														   locDict, (NSString*)kCGImagePropertyGPSDictionary,
														   exifDict, (NSString*)kCGImagePropertyExifDictionary, nil]);
	CGImageDestinationFinalize(dest);
	CFRelease(img);
	CFRelease(dest);
    
}
@end
