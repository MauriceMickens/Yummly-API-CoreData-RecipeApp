//
//  HomeViewController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 3/1/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "SearchListViewController.h"
#import "SearchResultCell.h"
#import "SearchResult.h"

static NSString * const HomeCellIdentifier = @"HomeCell";

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSArray *_categories;
    NSArray *_backgroundImages;
    NSIndexPath *_selectedIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 176;
    
    //UINib *cellNib = [UINib nibWithNibName:HomeCellIdentifier bundle:nil];
    //[self.tableView registerNib:cellNib forCellReuseIdentifier:HomeCellIdentifier];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
{       // Check for the correct segue
    if ([segue.identifier isEqualToString:@"ShowCategory"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        SearchListViewController *controller = (SearchListViewController *)navigationController.topViewController;
        
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
