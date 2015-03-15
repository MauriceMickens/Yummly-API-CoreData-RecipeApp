//
//  DetailViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/10/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "DetailViewController.h"

static NSString * const Detail0CellIdentifier = @"Detail0Cell";

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style: UIBarButtonItemStyleBordered
                                             target:self action:@selector(dismissMyView)];
    
    UINib *cellNib = [UINib nibWithNibName:Detail0CellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:Detail0CellIdentifier];
}

- (void)dismissMyView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
        return 3;
    if (section == 1)
        return 10;
    if (section == 2)
        return 1;
    if (section == 3)
        return 2;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Detail0CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0)
        cell.textLabel.text = @"Test1";
    
    if (indexPath.section == 1)
        cell.textLabel.text = @"Test2";
    
    if (indexPath.section == 2)
        cell.textLabel.text = @"Test3";
    
    if (indexPath.section == 3)
        cell.textLabel.text = @"Test4";
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"section1";
    if (section == 1)
        return @"section2";
    if (section == 2)
        return @"section3";
    if (section == 3)
        return @"section4";
    
    return @"undefined";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}




@end
