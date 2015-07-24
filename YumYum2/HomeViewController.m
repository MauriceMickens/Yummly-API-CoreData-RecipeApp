//
//  HomeViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/1/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "SearchListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SearchResultCell.h"
#import "SearchResult.h"

static NSString * const HomeCellIdentifier = @"HomeCell";
static NSString * const VegetarianDiet = @"&allowedDiet[]=387^Lacto-ovo vegetarian";
static NSString * const VeganDiet = @"&allowedDiet[]=386^Vegan";
static NSString * const PescetarianDiet = @"&allowedDiet[]=390^Pescetarian";
static NSString * const LactoVegDiet = @"&allowedDiet[]=388^Lacto vegetarian";
static NSString * const PaleoDiet = @"&allowedDiet[]=403^Paleo";

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSArray *_categories;
    NSArray *_backgroundImages;
    NSIndexPath *_selectedIndexPath;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        _categories = @[@"Vegetarian",
                        @"Vegan",
                        @"Pescetarian",
                        @"Lacto Vegetarian",
                        @"High Protien"];
        
        _backgroundImages = @[[UIImage imageNamed:@"Vegetarian.png"],
                              [UIImage imageNamed:@"Vegan.png"],
                              [UIImage imageNamed:@"Pescertarian.png"],
                              [UIImage imageNamed:@"Lacto.png"],
                              [UIImage imageNamed:@"Protein.png"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 264;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categories count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCell *cell = (HomeCell *)[tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier forIndexPath:indexPath];
    
    
    NSString *categoryName = _categories[indexPath.row];
    cell.dietLabel.text = categoryName;
    
    [cell.backgroundImageView setImage: _backgroundImages[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{    // Check for the correct segue
    if ([segue.identifier isEqualToString:@"ShowCategory"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        SearchListViewController *searchController = (SearchListViewController *)navigationController.topViewController;
        
        if (path.row == 0){
            [searchController searchRecipesFromHomeView:VegetarianDiet];
        } else if (path.row == 1){
            [searchController searchRecipesFromHomeView:VeganDiet];
        } else if (path.row == 2){
            [searchController searchRecipesFromHomeView:PescetarianDiet];
        } else if (path.row == 3){
            [searchController searchRecipesFromHomeView:LactoVegDiet];
        }else if (path.row == 4){
            [searchController searchRecipesFromHomeView:PaleoDiet];
        }
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disables selection for users if searchResults empty
    if ([_categories count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}

@end
