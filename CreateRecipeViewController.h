//
//  CreateRecipeViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/16/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailSearchResult;

#import "AddDirectionsViewController.h"

@interface CreateRecipeViewController : UIViewController

@property (nonatomic, strong) DetailSearchResult *detailSearchResult;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
