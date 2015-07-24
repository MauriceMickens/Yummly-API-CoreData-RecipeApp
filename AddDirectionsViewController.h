//
//  DirectionsViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddDirectionsViewController;
@class DirectionItem;

@protocol AddDirectionsViewControllerDelegate <NSObject>

- (void)addItemViewControllerDidCancel:(AddDirectionsViewController *)controller;

- (void)addItemViewController:(AddDirectionsViewController *)controller didFinishAddingItem:(DirectionItem *)item;

@end

@interface AddDirectionsViewController : UIViewController

@property (nonatomic, weak) id <AddDirectionsViewControllerDelegate> delegate;

@end
