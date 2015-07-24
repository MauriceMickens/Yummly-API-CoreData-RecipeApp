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
#import "Recipe.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "DetailIngredient.h"
#import "WebViewController.h"
#import <CoreData/CoreData.h>
#import "HudView.h"
#import "YumYum2Macros.h"

static NSString * const DetailIngredientsCellIdentifier = @"DetailIngredientsCell";
static NSString * const nibNameorNil = @"RecipeDetailViewController";
static const int NumberOfSections = 1;

@interface RecipeDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sourceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *servingsLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;


@property (nonatomic) NSURLSession *session;

@end

@implementation RecipeDetailViewController
{
    NSMutableArray *_ingredients;
    int ingredientCount;
    NSDate *_date;
    UIImage *_recipePhoto;
    NSMutableArray *_images;
    
}

- (instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (IBAction)save:(id)sender
{
    HudView *hudView = [HudView
                        hudInView:self.view animated:YES];
    hudView.text = @"Fressh Saved";
    
    // Create a Core Data Managed Object
    Recipe *recipe = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Recipe"
                          inManagedObjectContext:self.managedObjectContext];
    
    recipe.recipeName = self.detailSearchResult.recipeName;
    recipe.sourceRecipe = self.detailSearchResult.sourceRecipe[@"sourceDisplayName"];
    recipe.numberOfServings = self.detailSearchResult.numberOfServings;
    recipe.totalTime = self.detailSearchResult.totalTime;
    recipe.imageURL = self.detailSearchResult.bigImage;
    recipe.ingredientLines = self.detailSearchResult.ingredientLines;
    recipe.recipeURL = self.detailSearchResult.sourceRecipeURL;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    [self performSelector:@selector(closeScreen) withObject:nil
               afterDelay:0.6];
}
- (IBAction)getWebView:(id)sender {
    
    WebViewController *controller =
    [[WebViewController alloc]
     initWithNibName: @"WebViewController" bundle:nil];
    
    NSURL *URL = [NSURL URLWithString:self.detailSearchResult.sourceRecipeURL];
    
    controller.URL = URL;
    
    [self presentViewController:controller animated:YES
                     completion:nil];
    
    
}



- (void)closeScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    
    if (self.detailSearchResult != nil){
        [self updateUI];
        if (self.detailSearchResult.disableButton == YES){
            [self disableBarButtonItem];
        }
    }
    
    UINib *cellNib = [UINib nibWithNibName:DetailIngredientsCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:DetailIngredientsCellIdentifier];
}

-(void)disableBarButtonItem{
    self.navItem.rightBarButtonItem.enabled = NO;
}

- (void)updateUI
{
    self.recipeNameLabel.text = self.detailSearchResult.recipeName;
    
    if (self.detailSearchResult.stashSource == YES){
        if (self.detailSearchResult.source2 == nil){
            self.sourceNameLabel.text = @"Unknown";
        }
        self.sourceNameLabel.text = self.detailSearchResult.source2;
    }else {
        NSString *sourceDisplayName = [self.detailSearchResult.sourceRecipe objectForKey:@"sourceDisplayName"];
        if (sourceDisplayName == nil) {
            sourceDisplayName = @"Unknown";
        }
        self.sourceNameLabel.text = sourceDisplayName;
    }
    
    self.servingsLabel.text = [NSString stringWithFormat:@"%@",self.detailSearchResult.numberOfServings];
    self.totalTimeLabel.text = self.detailSearchResult.totalTime; 
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailSearchResult.bigImage]
                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self.artworkImageView setImageWithURLRequest:imageRequest
                                 placeholderImage:[UIImage imageNamed:@"Placeholder"]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                              self.artworkImageView.image = image;
                                          }
                                          failure:nil];
    
    
    ingredientCount = [self.detailSearchResult.ingredientLines count];
    _ingredients = [NSMutableArray arrayWithCapacity:ingredientCount];
    _date = [NSDate date];
    
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
