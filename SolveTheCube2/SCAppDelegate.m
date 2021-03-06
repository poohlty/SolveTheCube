//
//  SCAppDelegate.m
//  SolveTheCube2
//
//  Created by Tianyu Liu on 2/14/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import "SCAppDelegate.h"
#import "SCLearnViewController.h"
#import "UIColor+FlatUI.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UITabBar appearance] setTintColor:[UIColor peterRiverColor]];
    
    // crazy code. Programmatically trigger viewDidLoad, a very crazy design
    // This create a super super subtle bug in BookMark Controller:
    // we call viewDidLoad twice, and two placeholder images were added to the main
    // view. Thus we can't move away an instance of the placeholder image because we
    // can't have access to it.
    // Probably the previous buggy bookmark array is also caused by this. We actually
    // have duplicating tableview.
    
    // The code is fixed by using a category. Now it's much safer and clearer
    
    // Async load for tutorial
    UITabBarController *root = (UITabBarController *) self.window.rootViewController;
    for (UIViewController *controller in root.viewControllers) {
        //[controller setGrayTabBarItem];
        if ([controller isKindOfClass:[SCLearnViewController class]]){
            [(SCLearnViewController *)controller loadTutorial];
        }
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
