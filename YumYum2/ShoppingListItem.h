//
//  ShoppingListItem.h
//  YumYum2
//
//  Created by PhantomDestroyer on 3/4/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListItem : NSObject<NSCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;

- (void)toggleChecked;

@end
