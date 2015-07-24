//
//  EditItemViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/7/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "EditItemViewController.h"
#import "ShoppingListItem.h"

@interface EditItemViewController ()

- (IBAction)cancel;
- (IBAction)done;
@property (weak, nonatomic) IBOutlet UITextField *editTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;



@end

@implementation EditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.itemToEdit != nil) {
        // Change title in Navigation Bar
        self.title = @"Edit Item";
        // Set the text field of the EditViewController with ShoppingList item text
        self.editTextField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)cancel
{
    [self.delegate editItemViewControllerDidCancel:self];
}
- (IBAction)done
{
    // Set itemToEdit to text field 
    _itemToEdit.text = self.editTextField.text;
    
    [self.delegate editItemViewController:self didFinishEditingItem:_itemToEdit];
}

- (BOOL)textField:(UITextField *)theTextField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Determine what the new text will be
    NSString *newText = [theTextField.text
                         stringByReplacingCharactersInRange:range withString:string];
    // Enable or Disable done button if new text is empty
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    // Keyboard appears once screen is opened 
    [super viewWillAppear:animated];
    [self.editTextField becomeFirstResponder];
}
@end
