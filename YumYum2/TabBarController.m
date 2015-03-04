//
//  TabBarController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return nil;
}
@end
