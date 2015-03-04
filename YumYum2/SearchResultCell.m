//
//  SearchResultCell.m
//  StoreSearch
//
//  YumYum
//
//  Created by PhantomDestroyer on 1/15/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.

#import "SearchResultCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SearchResult.h"
#import "UIImage+ImageEffects.h"

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
  [super awakeFromNib];


}

- (void)configureForSearchResult:(SearchResult *)searchResult
{
    self.recipeLabel.text = searchResult.recipeName;
    
    self.sourceLabel.text = searchResult.sourceDisplayName;
    
    [self.artworkView setImageWithURL:
     [NSURL URLWithString:searchResult.imageUrlsBySize[@"90"]]
                          placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    self.artworkView.layer.borderWidth = 3.0f;
    self.artworkView.layer.cornerRadius = self.artworkView.bounds.size.width / 2.0f;
    self.artworkView.clipsToBounds = YES;

  

    
}


// Clear any image download thats still in progress and clear labels
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.artworkView cancelImageRequestOperation];
    self.recipeLabel.text = nil;
    self.sourceLabel.text = nil;
}

@end
