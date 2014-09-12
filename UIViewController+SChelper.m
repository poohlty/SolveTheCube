//
//  UIViewController+SChelper.m
//  SolveTheCube2
//
//  Created by Tianyu Liu on 5/6/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import "UIViewController+SChelper.h"
#import "MBProgressHUD.h"

@implementation UIViewController (SChelper)

- (void) setGrayTabBarItem{
    NSString *name = self.tabBarItem.title;
    UIImage *tabBarItemImg = [UIImage imageNamed:[NSString stringWithFormat: @"%@-icon-gray.png",name]];
    [self.tabBarItem setFinishedSelectedImage:tabBarItemImg withFinishedUnselectedImage:tabBarItemImg];
}

@end
