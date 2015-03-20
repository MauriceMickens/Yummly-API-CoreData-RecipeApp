//
//  CreateRecipeViewController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 3/16/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "CreateRecipeViewController.h"
#import "IngredientsViewController.h"
#import "DetailIngredientsCell.h"

static NSString * const IngredientsCellIdentifier = @"IngredientsCell";
static NSString * const DirectionsCellIdentifier = @"DirectionsCell";
static NSString * const CategoryCellIdentifier = @"CategoryCell";

@interface CreateRecipeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CreateRecipeViewController
{
    NSMutableArray *_ingredients;
    NSMutableArray *_directions;
    NSMutableArray *_category; 
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setAllowsSelection:YES];
    
    self.tableView.rowHeight = 88;
    
    UINib *cellNib = [UINib nibWithNibName:CategoryCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CategoryCellIdentifier];
    
    cellNib = [UINib nibWithNibName:DirectionsCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:DirectionsCellIdentifier];
    
    cellNib = [UINib nibWithNibName:IngredientsCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:IngredientsCellIdentifier];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
        return 1;
    if (section == 1)
        return 1;
    if (section == 2)
        return 1;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;

    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:DirectionsCellIdentifier];
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Ingredients";
    if (section == 1)
        return @"Directions";
    if (section == 2)
        return @"Directions";
    
    return @"undefined";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        // Create instance of the IngredientsViewController
        IngredientsViewController *ingredientsViewController =
        [[IngredientsViewController alloc]
         initWithNibName: @"IngredientsViewController" bundle:nil];
        
        [self presentViewController:ingredientsViewController animated:YES
                         completion:nil];
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)addNewIngredient:(id)sender
{
    // Get the row position for the new cell
    NSInteger newRowIndex = [_items count];
    
    // Create new ShoppingListItem object
    ShoppingListItem *item = [[ShoppingListItem alloc] init];
    
    // Set the item text to textfield text with no checkmark
    item.text = self.fTextField.text;
    item.checked = NO;
    
    // Add the updated ShoppingListItem object to the data model
    [_items addObject:item];
    
    // Set am indexPath object to point to newly created row
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:newRowIndex inSection:0];
    // Creates temporary array of indexPath objects
    NSArray *indexPaths = @[indexPath];
    
    // Insert new row in table view
    [self.resultTableView insertRowsAtIndexPaths:indexPaths
                                withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
 */


@end
