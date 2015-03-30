//
//  Recipe.h
//  YumYum2
//
//  Created by PhantomDestroyer on 3/29/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) id ingredientLines;
@property (nonatomic, retain) NSNumber * numberOfServings;
@property (nonatomic, retain) NSString * recipeName;
@property (nonatomic, retain) NSString * sourceRecipe;
@property (nonatomic, retain) NSString * totalTime;
@property (nonatomic, retain) NSString * recipeURL;

@end
