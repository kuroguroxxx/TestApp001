//
//  tfAppDelegate.h
//  TestApp001
//
//  Created by 高橋 聖二 on 12/07/24.
//  Copyright (c) 2012年 trifeed inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tfAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
