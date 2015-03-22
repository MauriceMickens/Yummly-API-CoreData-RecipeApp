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
#import <CoreData/CoreData.h>

static NSString * const DetailIngredientsCellIdentifier = @"DetailIngredientsCell";
static NSString * const nibNameorNil = @"RecipeDetailViewController";
static const int NumberOfSections = 1;

@interface RecipeDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceNameLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RecipeDetailViewController
{
    NSMutableArray *_ingredients;
    int ingredientCount;
    
}

- (instancetype)init{
    self = [super init];
    if(self){

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
    
    ingredientCount = [self.detailSearchResult.ingredientLines count];
    _ingredients = [NSMutableArray arrayWithCapacity:ingredientCount];
    
    for (int i = 0; i < ingredientCount; i++) {
        DetailIngredient *ingredient = [[DetailIngredient alloc] init];
        [_ingredients addObject:ingredient];
    }
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
    return NumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ingredientCount;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    DetailIngredientsCell *cell = (DetailIngredientsCell *)[tableView dequeueReusableCellWithIdentifier:DetailIngredientsCellIdentifier forIndexPath:indexPath];

    DetailIngredient *ingredient = _ingredients[indexPath.row];
    ingredient.name = self.detailSearchResult.ingredientLines[indexPath.row];
    cell.detailIngredient.text = ingredient.name;

    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Ingredients";
    return @"undefined";
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
