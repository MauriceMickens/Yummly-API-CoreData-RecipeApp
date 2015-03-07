//
//  ShoppingListViewController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 3/3/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "ShoppingListCell.h"
#import "ShoppingListItem.h"

static NSString * const ShoppingListCellIdentifier = @"ShoppingListCell";

@interface ShoppingListViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end

@implementation ShoppingListViewController
{
    NSMutableArray *_items;
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

    _items = [[NSMutableArray alloc] initWithCapacity:20];
    ShoppingListItem *item;
    
    item = [[ShoppingListItem alloc] init];
    item.text = @"Walk the dog";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ShoppingListItem  alloc] init];
    item.text = @"Brush my teeth";
    item.checked = YES;
    [_items addObject:item];
    
    item = [[ShoppingListItem alloc] init];
    item.text = @"Learn iOS development";
    item.checked = YES;
    [_items addObject:item];
    
    item = [[ShoppingListItem  alloc] init];
    item.text = @"Soccer practice";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ShoppingListItem  alloc] init];
    item.text = @"Eat ice cream";
    item.checked = YES;
    [_items addObject:item];
    

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    ShoppingListCell *cell = (ShoppingListCell *)[tableView dequeueReusableCellWithIdentifier:ShoppingListCellIdentifier forIndexPath:indexPath];
    
    // Get item for row in the array
    ShoppingListItem *item = _items[indexPath.row];
    
    // Set the properties of the cell with item properties
    cell.itemLabel.text = [item.text description];
    
    [self configureTextForCell:cell withShoppingListItem:item];
    [self configureCheckmarkForCell:cell withShoppingListItem:item];

    return cell;

}

- (void)configureCheckmarkForCell:(ShoppingListCell *)cell
             withShoppingListItem:(ShoppingListItem *)item
{
    if (item.checked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)configureTextForCell:(ShoppingListCell *)cell
           withShoppingListItem:(ShoppingListItem *)item
{   // Set item's text on cell label
    cell.itemLabel.text = item.text;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Get ShoppingList item object at the index that corresponds with the row number
    ShoppingListItem *item = _items[indexPath.row];
    
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withShoppingListItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (IBAction)addNewItem:(id)sender
{
    // Get the row position for the new cell
    NSInteger newRowIndex = [_items count];
    
    // Create new ShoppingListItem object
    ShoppingListItem *item = [[ShoppingListItem alloc] init];
    
    item.text = @"I am a new row";
    
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

# pragma mark - Textfield Delegate Method and Method to handle Button Touch-up Event

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
    
    [self.resultTableView reloadData];
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove item from data model
    [_items removeObjectAtIndex:indexPath.row];
    // Delete corresponding row from table view
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
