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

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

  UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
  selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5f];
  self.selectedBackgroundView = selectedView;

}

- (void)configureForSearchResult:(SearchResult *)searchResult
{
    self.recipeNameLabel.text = searchResult.recipeName;
    
    self.sourceNameLabel.text = searchResult.sourceDisplayName;
    
    
    [self.artworkImageView setImageWithURL:
     [NSURL URLWithString:searchResult.imageUrlsBySize[@"90"]]
                          placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}
                            
//Given a UIImage and a CGSize, this method will return a resized UIImage.
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return newImage;
}

// Clear any image download thats still in progress and clear labels
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.artworkImageView cancelImageRequestOperation];
    self.recipeNameLabel.text = nil;
    self.sourceNameLabel.text = nil;
}

@end
