//
//  RecipeDetailViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/11/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "DetailSearchResult.h"
#import "DetailIngredientsCell.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailIngredient.h"

static NSString * const DetailIngredientsCellIdentifier = @"DetaiLIngredients";

@interface RecipeDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceNameLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RecipeDetailViewController
{
    NSMutableArray *_ingredients;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ingredients = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    if (self.detailSearchResult != nil){
        [self updateUI];
    }
    
    UINib *cellNib = [UINib nibWithNibName:DetailIngredientsCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:DetailIngredientsCellIdentifier];
}

- (void)updateUI
{
    self.recipeNameLabel.text = self.detailSearchResult.recipeName;
    
    NSString *sourceDisplayName = self.detailSearchResult.sourceRecipe[@"sourceDisplayName"];
    if (sourceDisplayName == nil) {
        sourceDisplayName = @"Unknown";
    }
    self.sourceNameLabel.text = sourceDisplayName;
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.detailSearchResult.bigImage]]; 
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = 0;
 
    UITableViewCell *cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:DetailIngredientsCellIdentifier];
    
    for (DetailIngredient *element in self.detailSearchResult.ingredientLines){
        [_ingredients addObject:element];
        NSLog(@"%@",_ingredients[count]);
        count++; 
    }
    
    //DetailIngredient *ingredient = _ingredients[indexPath.row];
        
    // Set the contents of the cell
    cell.textLabel.text = @"TEST";
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Disables selection for users if searchResults empty or if connecting to server
    
    return indexPath;
    
}

@end
