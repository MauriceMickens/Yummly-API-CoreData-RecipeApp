//
//  SearchResultCell.h
//  StoreSearch
//
//  YumYum
//
//  Created by Maurice Mickens on 1/15/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.

#import <UIKit/UIKit.h>
@class SearchResult;

@interface SearchResultCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *recipeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkView;
@property (nonatomic, weak) IBOutlet UIImageView *logo;
@property (nonatomic, weak) IBOutlet UILabel *rating;
@property (nonatomic, weak) IBOutlet UILabel *prepTime;


- (void)configureForSearchResult:(SearchResult *)searchResult;

@end
