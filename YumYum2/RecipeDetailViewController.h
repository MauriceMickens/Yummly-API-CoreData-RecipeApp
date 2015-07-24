//
//  RecipeDetailViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/11/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@class DetailSearchResult;
@class WebViewController;

@interface RecipeDetailViewController : UIViewController

@property (nonatomic, strong) DetailSearchResult *detailSearchResult;
@property (nonatomic, strong) NSManagedObjectContext
*managedObjectContext;
@property (nonatomic) WebViewController *webViewController;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;


@end
