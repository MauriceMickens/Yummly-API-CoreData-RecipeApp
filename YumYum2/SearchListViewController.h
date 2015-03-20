//
//  SearchListViewController.h
//  YumYum2
//
//  Created by Maurice Mickens on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface SearchListViewController : UIViewController 

@property (nonatomic, strong) SearchResult *searchResult;

- (void)searchRecipesFromHomeView:(NSString *)searchText;



@end
