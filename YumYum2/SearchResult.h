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
@property (nonatomic, copy) NSDictionary *attribution; 
@property (nonatomic, copy) NSString *sourceDisplayName;
@property (nonatomic, copy) NSString *recipeID;
@property (nonatomic, copy) NSString *recipeName;
@property (nonatomic) NSNumber *totalTimeInSeconds;
@property (nonatomic, copy) NSNumber *rating;


@end
