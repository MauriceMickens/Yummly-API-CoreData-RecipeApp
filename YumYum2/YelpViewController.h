//
//  YelpViewController.h
//  YumYum2
//
//  Created by PhantomDestroyer on 2/24/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface YelpViewController : UITableViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *tableViewDisplayDataArray;

@property (weak, nonatomic) IBOutlet UITableView *YelpResultTableView;


@end
