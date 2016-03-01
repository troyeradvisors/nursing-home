//
//  TAAppDelegate.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "MapController.h"
#import "SummaryController.h"
#import "FilterController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) UIViewController* LastController;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ADBannerView* Ad;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSString *) DocumentsDirectory;
- (UIViewController*) CurrentController;
- (UINavigationController*) NavigationController;
- (UIView*) CurrentView;
@end
