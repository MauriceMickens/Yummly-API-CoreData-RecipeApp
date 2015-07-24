//
//  StashViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 3/26/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "StashViewController.h"
#import "SearchResultCell.h"
#import "DetailSearchResult.h"
#import "RecipeDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "YumYum2Macros.h"
#import "Recipe.h"
#import "AppDelegate.h"

static NSString * const SearchResultCellIdentifier = @"SearchResultCell";
static const int NumberOfSections = 1;

@interface StashViewController ()<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate>


@end

@implementation StashViewController
{
    NSFetchedResultsController *_fetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        // Fetches objects from data store
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // Tells fetch request which entity to retrieve
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Recipe"
                                       inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"recipeName" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        // Fecth only 20 objects at a time
        [fetchRequest setFetchBatchSize:20];
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:@"Recipes"];
                                    _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 132;

    
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication
                                                sharedApplication] delegate];
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [self performFetch];
    
}

- (void)performFetch
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
}

- (void)dealloc
{
    _fetchedResultsController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
        [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier forIndexPath:indexPath];
    
    Recipe *recipe = [self.fetchedResultsController
                       objectAtIndexPath:indexPath];
    cell.recipeLabel.text = recipe.recipeName;
    cell.sourceLabel.text = recipe.sourceRecipe;
    [cell configureForArtworkView:recipe.imageURL];

    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailSearchResult *result = [[DetailSearchResult alloc]init];
    
    RecipeDetailViewController *controller =
    [[RecipeDetailViewController alloc] init];
    
    Recipe *recipe = [self.fetchedResultsController
                      objectAtIndexPath:indexPath];
    result.recipeName = recipe.recipeName;
    result.stashSource = YES;
    result.source2 = recipe.sourceRecipe; 
    result.bigImage = recipe.imageURL;
    result.numberOfServings = recipe.numberOfServings;
    result.totalTime = recipe.totalTime;
    result.ingredientLines = recipe.ingredientLines;
    result.sourceRecipeURL = recipe.recipeURL;
    result.disableButton = YES; 
    controller.detailSearchResult = result;
    
    // Show the RecipeDetailViewController
    [self presentViewController:controller animated:YES
                     completion:nil];

    
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Recipe *recipe = [self.fetchedResultsController
                              objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:recipe];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            FATAL_CORE_DATA_ERROR(error);
            return;
        }
    }
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:
(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet
                                            indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet
                                            indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:
(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
