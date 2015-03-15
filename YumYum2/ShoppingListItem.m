//
//  ShoppingListItem.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/4/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "ShoppingListItem.h"

@implementation ShoppingListItem

- (void) toggleChecked
{
    self.checked = !self.checked; 
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // Retreive objects from the plist file
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Store objects in plist file
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
}

@end
