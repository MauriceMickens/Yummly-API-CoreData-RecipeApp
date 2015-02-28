//
//  SearchResultCell.h
//  StoreSearch
//
//  YumYum
//
//  Created by PhantomDestroyer on 1/15/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.

#import <UIKit/UIKit.h>
@class SearchResult;

@interface SearchResultCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *recipeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkView;

- (void)configureForSearchResult:(SearchResult *)searchResult;

@end
