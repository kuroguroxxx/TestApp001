//
//  tfRootViewController.h
//  TestApp001
//
//  Created by 高橋 聖二 on 12/07/24.
//  Copyright (c) 2012年 trifeed inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MapKit/MapKit.h>

@interface tfRootViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)btnTapAction:(UIButton *)sender;
- (IBAction)startCamera:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet MKMapView *viewMap;

- (BOOL)openCamera:(UIViewController*) controller usingDelegate: (id <UINavigationControllerDelegate,UIImagePickerControllerDelegate>) delegate;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
