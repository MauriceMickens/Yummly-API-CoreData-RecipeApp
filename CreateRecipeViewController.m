//
//  CreateRecipeViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/16/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "CreateRecipeViewController.h"
#import <CoreData/CoreData.h>
#import "IngredientsViewController.h"
#import "AddDirectionsViewController.h"
#import "CategoryPickerViewController.h"
#import "DetailIngredientsCell.h"
#import "DetailSearchResult.h"
#import "DirectionItem.h"
#import "MyTextField.h"
#import "HudView.h"
#import "Recipe.h"
#import <QuartzCore/QuartzCore.h>
#import "YumYum2Macros.h"

static NSString * const IngredientsCellIdentifier = @"IngredientsCell";
static NSString * const DirectionsCellIdentifier = @"DirectionsCell";
static NSString * const CategoryCellIdentifier = @"CategoryCell";
static NSString * const CreateRecipeCellIdentifier = @"CreatedRecipeCell";

@interface CreateRecipeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,AddDirectionsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *recipeTextField;
@property (weak, nonatomic) IBOutlet UITextField *servingsTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

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
    self.recipeTextField.text = @"";
    self.servingsTextField.text = @"";
    self.timeTextField.text = @"";
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
    
    recipe.recipeName = self.recipeTextField.text;
    
    NSNumberFormatter *fServings = [[NSNumberFormatter alloc] init];
    fServings.numberStyle = NSNumberFormatterDecimalStyle;
    recipe.numberOfServings = [fServings numberFromString:self.servingsTextField.text];

    recipe.totalTime = self.timeTextField.text;

    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    [self performSelector:@selector(closeScreen) withObject:nil
               afterDelay:0.6];
}

- (void)closeScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 88;
    self.recipeTextField.delegate = self;
    self.servingsTextField.delegate = self;
    self.timeTextField.delegate = self;
    
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
        return [_ingredients count];
    }
    if (section == 1){
        return [_directions count];
    }
    if (section == 2){
        return [_category count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;

    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:DirectionsCellIdentifier forIndexPath:indexPath];
        DirectionItem *item = _directions[indexPath.row];
        UILabel *label = (UILabel *)[cell viewWithTag:101];
        label.text = item.text;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 600.0, 22.0)];
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    headerBtn.backgroundColor = [UIColor redColor];
    headerBtn.frame = CGRectMake(10.0, 30.0, 300.0, 25.0);
    [headerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customView addSubview:headerBtn];
    
    if (section == 0){
        
        [customView setBackgroundColor:[UIColor redColor]];
        
        [headerBtn setTitle:@"Add Ingredients" forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(addIngredient:) forControlEvents:UIControlEventTouchUpInside];
        return customView;
    }
    if (section == 1){
        
        [customView setBackgroundColor:[UIColor redColor]];
        
        [headerBtn setTitle:@"Add Directions" forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(addDirections:) forControlEvents:UIControlEventTouchUpInside];
        return customView;
    }
    if (section == 2){
        
        [customView setBackgroundColor:[UIColor redColor]];
        
        [headerBtn setTitle:@"Add Category" forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(addCategory:) forControlEvents:UIControlEventTouchUpInside];
        return customView;
    }
    
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 88.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

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
    if ([self.recipeTextField isFirstResponder]) {
        [self.recipeTextField resignFirstResponder];
    }
    if ([self.servingsTextField isFirstResponder]){
        [self.servingsTextField resignFirstResponder];
    }
    if ([self.timeTextField isFirstResponder]){
        [self.timeTextField resignFirstResponder];
    }
    
    MyTextField *myTextField = [[MyTextField alloc]init];
    if (textField == self.recipeTextField) {
        self.recipeTextField.text = textField.text;
        myTextField.recipeTitle = self.recipeTextField.text;
        //NSLog(@"%@",myTextField.recipeTitle);
    }
    if (textField == self.servingsTextField) {
        self.servingsTextField.text = textField.text;
        myTextField.recipeServings = self.servingsTextField.text;
        //NSLog(@"%@",myTextField.recipeServings);
    }
    if (textField == self.timeTextField){
        self.servingsTextField.text = textField.text;
        myTextField.recipeTime = self.timeTextField.text;
        //NSLog(@"%@",myTextField.recipeTime);
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.recipeTextField isFirstResponder]) {
        [self.recipeTextField resignFirstResponder];
    }
    if ([self.servingsTextField isFirstResponder]){
        [self.servingsTextField resignFirstResponder];
    }
    if ([self.timeTextField isFirstResponder]){
        [self.timeTextField resignFirstResponder];
    }
    
}

- (void)addItemViewControllerDidCancel:(AddDirectionsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemViewController:(AddDirectionsViewController *)controller didFinishAddingItem:(DirectionItem *)item
{
    NSInteger newRowIndex = [_directions count];
    [_directions addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:1];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addIngredient:(id)sender
{
    IngredientsViewController *ingredientsViewController =
    [[IngredientsViewController alloc]
     initWithNibName: @"IngredientsViewController" bundle:nil];
    
    [self presentViewController:ingredientsViewController animated:YES
                     completion:nil];
    
}

- (void)addDirections:(id)sender
{
    AddDirectionsViewController *directionsViewController =
    [[AddDirectionsViewController alloc]
     initWithNibName: @"AddDirectionsViewController" bundle:nil];
    
    directionsViewController.delegate = self;
    
    [self presentViewController:directionsViewController animated:YES
                     completion:nil];
    
}

- (void)addCategory:(id)sender
{
    CategoryPickerViewController *categoryPickerViewController =
    [[CategoryPickerViewController alloc]
     initWithNibName: @"CategoryPickerViewController" bundle:nil];
    
    [self presentViewController:categoryPickerViewController animated:YES
                     completion:nil];
    
}



@end
