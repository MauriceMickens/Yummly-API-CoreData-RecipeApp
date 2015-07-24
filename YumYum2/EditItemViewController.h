//
//  EditItemViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/7/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditItemViewController;
@class ShoppingListItem;

@protocol EditItemViewControllerDelegate <NSObject>

- (void)editItemViewControllerDidCancel: (EditItemViewController *)controller;
- (void)editItemViewController:(EditItemViewController *)controller
          didFinishEditingItem:(ShoppingListItem *)item;
@end

@interface EditItemViewController : UITableViewController

@property (nonatomic, weak) id <EditItemViewControllerDelegate>
delegate;
@property (nonatomic, strong) ShoppingListItem *itemToEdit;


@end
