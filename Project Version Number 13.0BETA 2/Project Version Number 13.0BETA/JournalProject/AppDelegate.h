//
//  AppDelegate.h
//  JournalProject
//
//  Created by John S. Nelson on 10/27/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) IBOutlet ViewController *viewController;

- (NSURL *)applicationDocumentsDirectory;
+ (bool) isLoggedOut;
+ (void) log: (bool) direction;

@end

