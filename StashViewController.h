//
//  StashViewController.h
//  YumYum2
//
//  Created by PhantomDestroyer on 3/26/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface StashViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext
*managedObjectContext;

@end
