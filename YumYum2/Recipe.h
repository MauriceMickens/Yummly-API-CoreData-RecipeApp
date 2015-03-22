//
//  Recipe.h
//  YumYum2
//
//  Created by PhantomDestroyer on 3/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * recipeName;
@property (nonatomic, retain) NSData * sourceRecipe;
@property (nonatomic, retain) NSNumber * totalTimeInSeconds;
@property (nonatomic, retain) NSData * ingredientLines;
@property (nonatomic, retain) NSString * numberOfServings;

@end
