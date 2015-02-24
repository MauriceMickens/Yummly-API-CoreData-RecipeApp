//
//  SearchBarCustomSegue.m
//  YumYum2
//
//  Created by PhantomDestroyer on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "SearchBarCustomSegue.h"

@implementation SearchBarCustomSegue

- (void) perform
{
    UIView *sv = ((UIViewController *)self.sourceViewController).view;
    UIView *dv = ((UIViewController *)self.destinationViewController).view;
    
    [sv addSubview:dv];
    [self.sourceViewController addChildViewController:self.destinationViewController];
    [self.destinationViewController didMoveToParentViewController:self.sourceViewController];
    
}

@end
