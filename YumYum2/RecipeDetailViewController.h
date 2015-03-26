//
//  RecipeDetailViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/11/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h" 

@class DetailSearchResult;

@interface RecipeDetailViewController : UIViewController

@property (nonatomic, strong) DetailSearchResult *detailSearchResult;
@property (nonatomic, strong) NSManagedObjectContext
*managedObjectContext;

@end
