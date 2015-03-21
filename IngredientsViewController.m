//
//  IngredientsViewController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 3/16/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "IngredientsViewController.h"

@interface IngredientsViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *measurementPicker;

@end

@implementation IngredientsViewController
{
    NSArray *_measurementsArray;
    NSArray *_unitsArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Initialize Data
        _measurementsArray = @[@"-", @"1/4", @"1/3", @"1/2", @"2/3", @"3/4"];
        _unitsArray = @[@"unit",@"as needed",@"box",@"can",@"cup",@"gallon"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Connect data
    self.measurementPicker.dataSource = self;
    self.measurementPicker.delegate = self;
    
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0){
        return [_measurementsArray count];
    } else if (component == 1){
        return [_unitsArray count];
    }
    return 0;

}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0){
        return [_measurementsArray objectAtIndex:row];
    } else if (component == 1){
        return [_unitsArray objectAtIndex:row];
    }
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
