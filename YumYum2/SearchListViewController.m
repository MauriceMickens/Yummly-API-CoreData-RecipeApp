//
//  SearchListViewController.m
//  YumYum2
//
//  Created by Maurice Mickens on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchResultCell.h"
#import <AFNetworking/AFNetworking.h>
#import "RecipeDetailViewController.h"
#import "UIImage+Resize.h"
#import "DetailSearchResult.h"



static NSString * const SearchResultCellIdentifier = @"SearchResultCell";
static NSString * const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString * const LoadingCellIdentifier = @"LoadingCell";
static const int NumberOfSections = 1;


@interface SearchListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation SearchListViewController
{
    NSMutableArray *_searchResults;
    NSMutableArray *_detailSearchResults;
    BOOL _isLoading;
    NSOperationQueue *_queue;
    NSOperationQueue *_detailQueue;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        _detailQueue = [[NSOperationQueue alloc] init];
        _detailSearchResults = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 132;
    _searchBar.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (_isLoading) {
        return 1;
    } else if (_searchResults == nil) {
        return 0;
    } else if ([_searchResults count] == 0) {
        return 1;
    } else {
        return [_searchResults count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_isLoading) {
        // Return LoadingCell to tableView when connecting to server
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:LoadingCellIdentifier
                                 forIndexPath:indexPath];
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:100];
        [spinner startAnimating];
        return cell;
        
    } else if ([_searchResults count] == 0) { //Returns NothingFoundCell is searchResults empty
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier forIndexPath:indexPath];
        
    } else {    //Returns cell SearchResult Cell for each row in row in searchResults
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier forIndexPath:indexPath];
        
        SearchResult *searchResult = _searchResults[indexPath.row];
        
        // Set the contents of the cell
        [cell configureForSearchResult:searchResult];
        
        return cell;
    }
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Set searchResult of the selected row
    SearchResult *searchResult = _searchResults[indexPath.row];
    
    // Get the recipeID from the selected searchResult
    NSString *recipeID = searchResult.recipeID;
    
    // Get a URL object from search string recipeID
    NSURL *url = [self urlWithRecipeId:recipeID];
    
    // Get a request object for the server using url object
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Initiate request operation on the server
    AFHTTPRequestOperation *operation =
    [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Parse JSON from server
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^
     // Request and Serialization on the server was successful
     (AFHTTPRequestOperation *operation, id responseObject) {
         
         DetailSearchResult *result = [self parseDetailDictionary:responseObject];
         
         // Create instance of the RecipeDetailViewController
         RecipeDetailViewController *controller =
         [[RecipeDetailViewController alloc]
            initWithNibName: @"RecipeDetailViewController" bundle:nil];
         
         controller.detailSearchResult = result;
         
         // Show the RecipeDetailViewController
         [self presentViewController:controller animated:YES
                          completion:nil];
         
         // Request was a failure
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         // Prevents error msg when failure block is invoked
         if (operation.isCancelled) {
             return;
         }
         [self showNetworkError];
         _isLoading = NO;
         [self.tableView reloadData];
     }];
    
    [_detailQueue addOperation:operation];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     //Disables selection for users if searchResults empty or if connecting to server
    if ([_searchResults count] == 0 || _isLoading) {
        return nil;
    } else {
        return indexPath;
    }
    
}

#pragma mark - UISearchBarDelegate
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if ([searchBar.text length] > 0) {
        
        _isLoading = YES;
        [self.tableView reloadData];
        
        // Dismiss keyboard after search begins
        [searchBar resignFirstResponder];
        
        // Cancels old searches if new search is peformed
        [_queue cancelAllOperations];
        
        // Initialize searchResults array with 20 elements
        _searchResults = [NSMutableArray arrayWithCapacity:20];
    
        
        // Get a URL object from search string
        NSURL *url = [self urlWithSearchText:searchBar.text];
        
        [self afNetworkingStuff:url];
        
    }
    
}

- (void)searchRecipesFromHomeView:(NSString *)searchText
{
   
    _isLoading = YES;
    [self.tableView reloadData];
    
    // Cancels old searches if new search is peformed
    [_queue cancelAllOperations];
        
    // Initialize searchResults array with 20 elements
    _searchResults = [NSMutableArray arrayWithCapacity:20];
        
        
    // Get a URL object from search string
    NSURL *url = [self urlWithSearchText:searchText];
        
    [self afNetworkingStuff:url];
    
}

- (void)afNetworkingStuff:(NSURL *)url
{
    
    // Get a request object for the server using url object
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Initiate request operation on the server
    AFHTTPRequestOperation *operation =
    [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Parse JSON from server
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^
     // Request and Serialization on the server was successful
     (AFHTTPRequestOperation *operation, id responseObject) {
         
         [self parseDictionary:responseObject];
         _isLoading = NO;
         [self.tableView reloadData];
         
         // Request was a failure
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         // Prevents error msg when failure block is invoked
         if (operation.isCancelled) {
             return;
         }
         
         [self showNetworkError];
         _isLoading = NO;
         [self.tableView reloadData];
     }];
    
    [_queue addOperation:operation];

}

- (NSString *)performStoreRequestWithURL:(NSURL *)url
{
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url
                                                      encoding:NSUTF8StringEncoding error:&error];
    if (resultString == nil) {
        NSLog(@"Download Error: %@", error);
        return nil;
    }
    return resultString;
}

- (NSURL *)urlWithSearchText:(NSString *)searchText
{
    
    // Call the "stringByAddingPercentEscapesUsingEncoding" method to escape speacial characters
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Builds the URL as a string by putting text from search bar behing the "term" parameter
    NSString *urlString = [NSString stringWithFormat:
                           @"http://api.yummly.com/v1/api/recipes?_app_id=931de797&_app_key=fd48f14cdc64094977eaf86a7906d50b&q=%@&maxResult=500&start=10&requirePictures=true", escapedSearchText];
    
    // Turns "urlString" into a NSURL object
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

- (NSURL *)urlWithRecipeId:(NSString *)searchText
{
    
    // Call the "stringByAddingPercentEscapesUsingEncoding" method to escape speacial characters
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Builds the URL as a string by putting text from search bar behing the "term" parameter
    NSString *urlString = [NSString stringWithFormat:
                           @"http://api.yummly.com/v1/api/recipe/%@?_app_id=931de797&_app_key=fd48f14cdc64094977eaf86a7906d50b", escapedSearchText];
    
    // Turns "urlString" into a NSURL object
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}



- (void)parseDictionary:(NSDictionary *)dictionary
{
    // Get the "attribution" dictionary from the Yummly Server
    NSDictionary *attribution = dictionary[@"attribution"];

    // Get an array of dictionaries from the the Yummly Server
    NSArray *array = dictionary[@"matches"];
    if (array == nil) {
   
         NSLog(@"Expected 'results' array");
        return;
    }
    
    // For each dictionary in the array of dictionaries create a SearchResult
    // and add it the searchResults array 
    for (NSDictionary *matchDict in array) {
        
        SearchResult *searchResult;
        
        searchResult = [self parseRecipe:matchDict];
        
        searchResult.attribution = attribution;
        
        if (searchResult != nil){
            [_searchResults addObject:searchResult];
    
        }
        
    }
    
}

- (DetailSearchResult *)parseDetailDictionary:(NSDictionary *)dictionary
{
    NSString *recipeName = dictionary[@"name"];
    //NSLog(@"RecipeName: %@",recipeName);
    
    NSString *totalTime = dictionary[@"totalTime"];
    /*if (totalTime == nil){
        NSLog(@"Expected 'totalTime' string");
        return;
    }*/
    NSDictionary *recipeSource = dictionary[@"source"];
    /*if (recipeSource == nil){
        NSLog(@"Expected 'recipeSource' dictionary");
        return;
    }*/
    NSArray *arrayImages = dictionary[@"images"];
    /*if (arrayImages == nil){
        NSLog(@"Expected 'arrayImages' array");
        return;
    }*/
    NSArray *arrayIngredients = dictionary[@"ingredientLines"];
    /*if (arrayIngredients == nil){
        NSLog(@"Expected 'arrayIngredients' NSArray");
        return;
    }*/
    NSDictionary *attribution = dictionary[@"attribution"];
    /*if (attribution == nil){
        NSLog(@"Expected 'attribution' dictionary");
        return;
    }*/
    NSArray *numberOfServings = dictionary[@"numberOfServings"];
    /*if (numberOfServings == nil){
        NSLog(@"Expected 'numberOfServings' array");
        return;
    }*/
    
    DetailSearchResult *detailSearchResult = [[DetailSearchResult alloc]init];
    
    detailSearchResult.recipeName = recipeName;
    //NSLog(@"detailSearchResult: %@",detailSearchResult.recipeName);
    
    detailSearchResult.totalTime = totalTime;
    //NSLog(@"detailSearchResult: %@",detailSearchResult.totalTime);
    
    detailSearchResult.sourceRecipe = recipeSource;
    //NSLog(@"detailSearchResult: %@",detailSearchResult.sourceRecipe[@"sourceDisplayName"]);
    
    for (NSDictionary *dict in arrayImages){
        detailSearchResult.bigImage = dict[@"hostedLargeUrl"];
    }
    
    detailSearchResult.ingredientLines = arrayIngredients;
    
    return detailSearchResult;
    
}

- (SearchResult *)parseRecipe:(NSDictionary *)dictionary
{
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.imageUrlsBySize = dictionary[@"imageUrlsBySize"];
    searchResult.sourceDisplayName = dictionary[@"sourceDisplayName"];
    searchResult.recipeID = dictionary[@"id"];
    searchResult.recipeName = dictionary[@"recipeName"];
    searchResult.totalTimeInSeconds = dictionary[@"totalTimeInSeconds"];
    searchResult.rating = dictionary[@"rating"];
    
    return searchResult;
}


- (void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Whoops..."
                              message:@"There was an error reading from the Yummly. Please try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [alertView show];
}
@end
