//
//  SearchResult.h
//  StoreSearch
//
//  Created by Maurice Mickens on 01-29-15.
// 
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property (nonatomic, copy) NSDictionary *imageUrlsBySize;
@property (nonatomic, copy) NSString *sourceDisplayName;
@property (nonatomic, copy) NSArray  *ingredients;
@property (nonatomic, copy) NSString *recipeID;
@property (nonatomic, copy) NSString *recipeName;
@property (nonatomic, copy) NSArray  *smallImageUrls;
@property (nonatomic, copy) NSString *recipeNmae;
@property (nonatomic) NSNumber *totalTimeInSeconds;
@property (nonatomic, copy) NSDictionary *attributes;
@property (nonatomic, copy) NSDictionary *flavors;
@property (nonatomic) NSNumber *rating;


@end
