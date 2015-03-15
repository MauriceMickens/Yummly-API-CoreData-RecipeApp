//
//  RecipeDetailViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/11/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "DetailSearchResult.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+Resize.h"

@interface RecipeDetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UIButton *priceButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.detailSearchResult != nil){
        [self updateUI];
    }
}

- (void)updateUI
{
    self.recipeNameLabel.text = self.detailSearchResult.recipeName;
    
    NSString *sourceDisplayName = self.detailSearchResult.sourceRecipe[@"sourceDisplayName"];
    if (sourceDisplayName == nil) {
        sourceDisplayName = @"Unknown";
    }
    self.sourceNameLabel.text = sourceDisplayName;
    
    //[self.artworkImageView setImageWithURL:[NSURL URLWithString:self.searchResult.imageUrlsBySize[@"90"]]];
    
}

- (void)dealloc
{
    
    [self.artworkImageView cancelImageRequestOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
