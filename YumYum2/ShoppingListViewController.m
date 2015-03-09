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
#import "EditItemViewController.h"
#import "ShoppingList.h"

static NSString * const ShoppingListCellIdentifier = @"ShoppingListCell";

@interface ShoppingListViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,EditItemViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fTextField;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ShoppingListViewController
{
    NSMutableArray *_items;
}

- (void)loadChecklistItems
{
    // Get file from path of the data file
    NSString *path = [self dataFilePath];
    
    // Check to see if file exits
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        // If ShoppingList.plist exists load the data in the array of items
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        
        _items = [unarchiver decodeObjectForKey:@"ShoppinglistItems"];
        
        [unarchiver finishDecoding];
    } else {
        // If there there is no ShoppingList.plist
        _items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self loadChecklistItems];
    }
    return self;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}
- (NSString *)dataFilePath
{
    return [[self documentsDirectory]
            stringByAppendingPathComponent:@"ShoppingList.plist"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.shoppingList.name;
}

- (IBAction)cancel
{
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveShoppingListItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    
    [archiver encodeObject:_items forKey:@"ShoppinglistItems"];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
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
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
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
    
    [self saveShoppingListItems];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (IBAction)addNewItem:(id)sender
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditItem"]){
        // Get the Navigation bar controller from storyboard
        UINavigationController *navigationController = segue.destinationViewController;
        
        // Get the embeded view controller(EditItemViewController)
        EditItemViewController *controller =
            (EditItemViewController *)navigationController.topViewController;
        
        //Set delegate so self.ViewController is notified of user actions
        controller.delegate = self;
        
        // Get the row number from the tapped disclosure button in cell
        NSIndexPath *indexPath = [self.resultTableView indexPathForCell:sender];
        
        // Obtain and set shopping list item to edit
        controller.itemToEdit = _items[indexPath.row];
    }
}

# pragma mark - Textfield Delegate Method and Method to handle Button Touch-up Event

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.fTextField isFirstResponder]) {
        [self.fTextField resignFirstResponder];
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.fTextField isFirstResponder]) {
        [self.fTextField resignFirstResponder];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove item from data model
    [_items removeObjectAtIndex:indexPath.row];
    
    [self saveShoppingListItems];
    
    // Delete corresponding row from table view
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)editItemViewControllerDidCancel:(EditItemViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editItemViewController:(EditItemViewController *)controller didFinishEditingItem:(ShoppingListItem *)item
{
    NSInteger index = [_items indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    ShoppingListCell *cell = [self.resultTableView
                             cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withShoppingListItem:item];
    
    [self saveShoppingListItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
