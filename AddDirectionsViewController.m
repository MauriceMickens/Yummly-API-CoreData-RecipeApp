//
//  DirectionsViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "AddDirectionsViewController.h"
#import "DirectionItem.h"

@interface AddDirectionsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@end

@implementation AddDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textField becomeFirstResponder];

}

- (IBAction)cancel
{
    [self.delegate addItemViewControllerDidCancel:self];
}

- (IBAction)done
{
    DirectionItem *item = [[DirectionItem alloc] init];
    item.text = self.textField.text;
    
    [self.delegate addItemViewController:self didFinishAddingItem:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length] > 0);
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
