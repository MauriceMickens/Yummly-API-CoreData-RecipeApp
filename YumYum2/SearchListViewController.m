//
//  SearchListViewController.m
//  YumYum2
//
//  Created by PhantomDestroyer on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
#import <AFNetworking/AFNetworking.h>

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
    BOOL _isLoading;
    NSOperationQueue *_queue;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        // Initialize searchResults array with 10 elements
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        
        // Get a URL object from search string
        NSURL *url = [self urlWithSearchText:searchBar.text];
        
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
                           @"http://api.yummly.com/v1/api/recipes?_app_id=931de797&_app_key=fd48f14cdc64094977eaf86a7906d50b&q=%@", escapedSearchText];
    
    // Turns "urlString" into a NSURL object
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}


- (void)parseDictionary:(NSDictionary *)dictionary
{
    
    NSArray *array = dictionary[@"matches"];
    if (array == nil) {
   
         NSLog(@"Expected 'results' array");
        return;
    }
    
    for (NSDictionary *matchDict in array) {
        
        SearchResult *searchResult;
        
        searchResult = [self parseRecipe:matchDict];
        
        if (searchResult != nil){
            [_searchResults addObject:searchResult];
        }
    }
    
}

- (SearchResult *)parseRecipe:(NSDictionary *)dictionary
{
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.imageUrlsBySize = dictionary[@"imageUrlsBySize"];
    searchResult.sourceDisplayName = dictionary[@"sourceDisplayName"];
    searchResult.ingredients = dictionary[@"ingredients"];
    searchResult.recipeID = dictionary[@"id"];
    searchResult.smallImageUrls = dictionary[@"smallImageUrls"];
    searchResult.recipeName = dictionary[@"recipeName"];
    searchResult.totalTimeInSeconds = dictionary[@"totalTimeInSeconds"];
    searchResult.attributes = dictionary[@"attributes"];
    searchResult.flavors = dictionary[@"flavors"];
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
