//
//  TAAppDelegate.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Data.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize Ad;
@synthesize LastController;

- (ADBannerView*) Ad{
    if (Ad == nil)
    {
        Ad = [[ADBannerView alloc] init]; //:CGRectMake(0, 460, 320, 50)];
        Ad.delegate = self;
        [self AdOff];
    }
    return Ad;
}

- (UINavigationController*) NavigationController
{
    return (UINavigationController*) self.window.rootViewController;
}

- (UIViewController*) CurrentController
{
    return self.NavigationController.visibleViewController;
}

- (UIView*) CurrentView
{
    return self.CurrentController.view;
}

- (void)UpdateCloudItems:(NSNotification*)notification {
    // Get the list of keys that changed.
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    reason = [reasonForChange integerValue];
    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        // If something is changing externally, get the changes
        // and update the corresponding keys locally.
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        // This loop assumes you are using the same key names in both
        // the user defaults database and the iCloud key-value store
        for (NSString* key in changedKeys) {
            id value = [store objectForKey:key];
            [userDefaults setObject:value forKey:key];
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self Ad];
    [self persistentStoreCoordinator];
    [self NavigationController].delegate = self;
    self.LastController = [self CurrentController];

    
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateCloudItems:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:store];
    [store synchronize];
    
    [Global UserID]; // force load userid from cloud
    
    return YES;
}

 - (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray* stack = [navigationController viewControllers];
    UIViewController* current = self.LastController;
    UIViewController *next = viewController;
        self.LastController = next;
    UIView* move;
    if ([self ControllerNeedsAd:next])
    {
        CGRect frame = next.view.bounds;
        int screenHeight = [[UIScreen mainScreen] bounds].size.height;
        double height = [next isKindOfClass:[FilterController class]] ? (screenHeight-64)+44 : [next isKindOfClass:[SummaryController class]] ? (screenHeight-20)-44 : (screenHeight-64)+0;
        
        [self Ad].frame = CGRectMake(0, height +(IsAdVisible ? -50: 0), frame.size.width, 50);
                
        if (![next.view.subviews containsObject:[self Ad]])
        {
            [next.view addSubview:[self Ad]];
        }
        
        if (IsAdVisible)
        {
            move = [self AdResizeView:next];
            CGRect rect = move.frame;
            rect.size.height -= 50;
            move.frame = rect;
        }

    }
    
    if (current!=nil && [self ControllerNeedsAd:current])
    {
        if (IsAdVisible)
        {
            move = [self AdResizeView:current];
            CGRect rect = move.frame;
            rect.size.height += 50;
            move.frame = rect;
            // always move offscreen when leaving a view so we can assume its offscreen when navigating back to or to a view.
        }
    }
    


}

 - (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
 {
     [self AdOff];
 }

- (void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self AdOn];
}

- (bool)ControllerNeedsAd:(UIViewController*)controller
{
    return !DISABLE_ADS && [controller respondsToSelector:@selector(AdResizeView)];
}


-(UIView*)AdResizeView:(UIViewController*)c
{
    c = c ?: [self CurrentController];
    if ([c respondsToSelector:@selector(AdResizeView)])
    {
        return (UIView*)[c valueForKey:@"AdResizeView"];
    }
    return nil;
}

bool IsAdVisible = false;
//- (bool) IsAdVisible { return [[self Ad] isBannerLoaded]; }
-(void) AdOff
{
    //NSLog(@"Want to hide ad");
    if (IsAdVisible)
    {
        [self.Ad moveOffScreen:[self AdResizeView:nil]];
        IsAdVisible = false;
    }
}

-(void) AdOn
{
    //NSLog(@"Want to show ad");
    if (!IsAdVisible)
    {
        [self.Ad moveOnScreen:[self AdResizeView:nil]];
        IsAdVisible = true;
    }
}  

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[Global data] Save];
    //[self saveContext];
    
    
    // 5 seconds to quit before force shut down!  So run on background thread instead for additional time.
    
    /*
        NSLog(@"Application entered background state.");
        // UIBackgroundTaskIdentifier bgTask is instance variable
        // UIInvalidBackgroundTask has been renamed to UIBackgroundTaskInvalid
        NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
        
        bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [application endBackgroundTask:self->bgTask];
                self->bgTask = UIBackgroundTaskInvalid;
            });
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            while ([application backgroundTimeRemaining] > 1.0) {
                NSString *friend = [self checkForIncomingChat];
                if (friend) {
                    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                    if (localNotif) {
                        localNotif.alertBody = [NSString stringWithFormat:
                                                NSLocalizedString(@"%@ has a message for you.", nil), friend];
                        localNotif.alertAction = NSLocalizedString(@"Read Msg", nil);
                        localNotif.soundName = @"alarmsound.caf";
                        localNotif.applicationIconBadgeNumber = 1;
                        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Your Background Task works",ToDoItemKey, @"Message from javacom", MessageTitleKey, nil];
                        localNotif.userInfo = infoDict;
                        [application presentLocalNotificationNow:localNotif];
                        [localNotif release];
                        friend = nil;
                        break;
                    }
                }
            }
            [application endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        });
    
    */

    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[Global data] Save];
    //[self saveContext];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        } 
        
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
        __managedObjectContext.undoManager = nil; // I added this:  it speeds processing up.
    
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NursingHomeModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NursingHome.sqlite"];
    NSString *storePath = [[self DocumentsDirectory] stringByAppendingPathComponent:@"NursingHome.sqlite"];
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // comment out the below if statement in order to recreate database afresh.
    /*if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] 
                                      pathForResource:@"NursingHome" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }*/
    
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString*)DocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0]; 
}

@end
