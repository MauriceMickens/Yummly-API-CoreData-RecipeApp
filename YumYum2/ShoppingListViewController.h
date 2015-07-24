//
//  ShoppingListViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/3/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemViewController.h"

@class ShoppingList;

@interface ShoppingListViewController : UIViewController

@property (nonatomic, strong) ShoppingList *shoppingList;

@end
