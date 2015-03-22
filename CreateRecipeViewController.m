//
//  CreateRecipeViewController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 3/16/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "CreateRecipeViewController.h"
#import "IngredientsViewController.h"
#import "AddDirectionsViewController.h"
#import "CategoryPickerViewController.h"
#import "DetailIngredientsCell.h"
#import "DirectionItem.h"
#import "RecipeTitle.h"

static NSString * const IngredientsCellIdentifier = @"IngredientsCell";
static NSString * const DirectionsCellIdentifier = @"DirectionsCell";
static NSString * const CategoryCellIdentifier = @"CategoryCell";
static NSString * const CreateRecipeCellIdentifier = @"CreatedRecipeCell";

@interface CreateRecipeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,AddDirectionsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CreateRecipeViewController
{
    NSMutableArray *_ingredients;
    NSMutableArray *_directions;
    NSMutableArray *_category;
    UIImage *_image;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
- (IBAction)clearScreen:(id)sender {
    
    [self.view endEditing:YES];
    self.textField.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 88;
    self.textField.delegate = self;
    
    _directions = [[NSMutableArray alloc] init];
    
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
    if (section == 0){
        NSLog(@"Ingredients");
        return 1;
    }
    if (section == 1)
    {
        if ([_directions count] == 0){
            NSLog(@"RowReturn0Array Count:%lu",(unsigned long)[_directions count]);
            return 1;
        }
        else{
            NSLog(@"RowReturn>Array Count:%lu",(unsigned long)[_directions count]);
            return [_directions count];
        }
    }
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
        if (indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:DirectionsCellIdentifier forIndexPath:indexPath];
        }else
            cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
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
        return @"Categories";
    
    return @"undefined";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        IngredientsViewController *ingredientsViewController =
        [[IngredientsViewController alloc]
         initWithNibName: @"IngredientsViewController" bundle:nil];
        
        [self presentViewController:ingredientsViewController animated:YES
                         completion:nil];
        
    }
    if(indexPath.section == 1)
    {
        AddDirectionsViewController *directionsViewController =
        [[AddDirectionsViewController alloc]
         initWithNibName: @"AddDirectionsViewController" bundle:nil];
        
        directionsViewController.delegate = self;
        
        [self presentViewController:directionsViewController animated:YES
                         completion:nil];
    }
    if(indexPath.section == 2)
    {
        CategoryPickerViewController *categoryPickerViewController =
        [[CategoryPickerViewController alloc]
         initWithNibName: @"CategoryPickerViewController" bundle:nil];
        
        [self presentViewController:categoryPickerViewController animated:YES
                         completion:nil];
        
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (IBAction)getPhoto:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];


}

- (void)showImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.hidden = NO;
}

- (void)takePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES
                     completion:nil];
}

- (void)choosePhotoFromLibrary
{
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES
                     completion:nil];
}

- (void)showPhotoMenu
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Take Photo", @"Choose From Library",
                                      nil];
        [actionSheet showInView:self.view];
    } else {
        [self choosePhotoFromLibrary];
    }
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take image picker off the screen -
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self choosePhotoFromLibrary];
    }
}

# pragma mark - Textfield Delegate Method and Method to handle Button Touch-up Event

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    
    RecipeTitle *recipetitle = [[RecipeTitle alloc]init];
    recipetitle.text = self.textField.text;
    NSLog(@"%@",recipetitle.text);
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    
}

- (void)addItemViewControllerDidCancel:(AddDirectionsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemViewController:(AddDirectionsViewController *)controller didFinishAddingItem:(DirectionItem *)item
{
    NSInteger newRowIndex = [_directions count];
    NSLog(@"InititalArray Count:%lu",(unsigned long)[_directions count]);
    
    if (newRowIndex == 0){
        newRowIndex = 1;
    }
    NSLog(@"NewRowIndex:%ld",(long)newRowIndex);
    
    NSLog(@"ItemName:%@",item.text);
    [_directions addObject:item];
    
    NSLog(@"PostArray Count:%lu",(unsigned long)[_directions count]);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:1];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
