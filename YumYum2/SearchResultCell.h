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

@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

- (void)configureForSearchResult:(SearchResult *)searchResult;

@end
