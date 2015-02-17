//
//  MainViewController.m
//  Yelp
//
//  Template Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//
//  Additional Functionality Created by Peter Bai on 2/09/15.
//  Copyright (c) 2015 Peter Bai.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "CPBusiness.h"
#import "CPBusinessCell.h"
#import "FiltersViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import <SVProgressHUD.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import <CEReversibleAnimationController.h>
#import <CEBaseInteractionController.h>
#import <CETurnAnimationController.h>
#import <CEHorizontalSwipeInteractionController.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";
NSInteger const infiniteSearchOffsetIncrement = 20;

@interface MainViewController ()
<UITableViewDataSource,
UITableViewDelegate,
FiltersViewControllerDelegate,
MapViewControllerDelegate,
UISearchBarDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSDictionary *region;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic) NSInteger offset;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) CETurnAnimationController *animationController;
@property (nonatomic, strong) CEHorizontalSwipeInteractionController *interactionController;

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;
- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params showProgress:(BOOL)showProgress append:(BOOL)append;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
        self.animationController = [[CETurnAnimationController alloc] init];
        self.interactionController = [[CEHorizontalSwipeInteractionController alloc] init];
    }
    return self;
}

#pragma mark View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchBusinessesWithQuery:self.searchTerm params:nil showProgress:YES append:NO];
    self.title = @"Yelp";
    
    // Set up tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CPBusinessCell" bundle:nil] forCellReuseIdentifier:@"CPBusinessCell"];
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self fetchAdditionalBusinessesWithQuery:self.searchTerm params:self.filters];
    }];
    
    // Set up infinite scrolling
    UIView *infiniteScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    UILabel *infiniteScrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    infiniteScrollLabel.text = @"More...";
    infiniteScrollLabel.textColor = [UIColor grayColor];
    infiniteScrollLabel.textAlignment = NSTextAlignmentCenter;
    infiniteScrollLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [infiniteScrollView addSubview:infiniteScrollLabel];
    
    [self.tableView.infiniteScrollingView setCustomView:infiniteScrollView forState:SVInfiniteScrollingStateTriggered];

    // Customize navigation bar
    [self setMainNavigationBarItems];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:206.0/255
                                                                           green:21.0/255
                                                                            blue:6.0/255
                                                                           alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    
    // Set up search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 210.0, 44.0)];
    self.searchBar.tintColor = [UIColor colorWithRed:57.0/255
                                          green:64.0/255
                                           blue:142.0/255
                                          alpha:1.0];
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.delegate = self;
    self.searchBar.text = self.searchTerm;
    self.navigationItem.titleView = self.searchBar;
}

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    self.searchBar.text = self.searchTerm;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Custom getters

- (NSString *)searchTerm {
    if ([_searchTerm length] == 0) {
        return @"Restaurants";
    } else {
        return _searchTerm;
    }
}

#pragma mark Filter delegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    [self fetchBusinessesWithQuery:self.searchTerm params:filters showProgress:YES append:NO];
    self.filters = filters;
}

#pragma mark Searchbar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchNavigationBarItems];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTerm = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Searching for query: %@, params: %@", self.searchTerm, nil);
    [self fetchBusinessesWithQuery:self.searchTerm params:nil showProgress:YES append:NO];
    [self.searchBar resignFirstResponder];
    [self setMainNavigationBarItems];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self setMainNavigationBarItems];
}

#pragma mark MapViewDelegate methods

- (void)mapViewController:(MapViewController *)mvc search:(NSString *)query withFilters:(NSDictionary *)filters inRegion:(MKCoordinateRegion)region{
    NSLog(@"Mapviewcontroller called for search");
    [self fetchBusinessesWithQuery:query params:filters showProgress:YES append:NO];
}

- (void)mapViewController:(MapViewController *)mvc setSearchTerm:(NSString *)searchTerm {
    self.searchTerm = searchTerm;
}

#pragma mark UINavigationController delegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[DetailViewController class]] ||
        [fromVC isKindOfClass:[DetailViewController class]]) {
        return nil;

    } else {
        self.animationController.reverse = operation == UINavigationControllerOperationPop;
        return self.animationController;
    }
}

//- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    
//    return self.interactionController.interactionInProgress ? self.interactionController : nil;
//}

#pragma mark Private methods

- (void)onFilterButton {
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onMapButton {
    MapViewController *mvc = [[MapViewController alloc] init];
    mvc.searchTerm = self.searchTerm;
    mvc.businesses = self.businesses;
    mvc.region = self.region;
    mvc.delegate = self;
    
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)setMainNavigationBarItems {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Filter"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onFilterButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Map"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(onMapButton)];
}

- (void)setSearchNavigationBarItems {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(searchBarCancelButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(searchBarSearchButtonClicked:)];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self fetchBusinessesWithQuery:query params:params showProgress:NO append:NO];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params showProgress:(BOOL)showProgress append:(BOOL)append {
    if (showProgress) {
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
        [SVProgressHUD setRingThickness:4];
        [SVProgressHUD show];
    }
    
    NSLog(@"Searching for: \"%@\", with params: %@", query, params);
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        self.region = response[@"region"];
        
        if (append) {
            self.businesses = [self.businesses arrayByAddingObjectsFromArray:
                               [CPBusiness businessesWithDictionaries:businessDictionaries]];
            self.offset += infiniteSearchOffsetIncrement;
        
        } else {
            self.businesses = [CPBusiness businessesWithDictionaries:businessDictionaries];
            self.offset = self.businesses.count;
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        [self.tableView.infiniteScrollingView stopAnimating];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        [SVProgressHUD dismiss];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)fetchAdditionalBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionary];
    [allParameters addEntriesFromDictionary:params];

    NSDictionary *limitAndOffset = @{@"limit": @20,
                                     @"offset": [NSNumber numberWithInt:(int)self.offset]};
    [allParameters addEntriesFromDictionary:limitAndOffset];

    [self fetchBusinessesWithQuery:query params:allParameters showProgress:NO append:YES];
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPBusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.business = self.businesses[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark Gesture methods

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
//    CGPoint location = [sender translationInView:self.tableView];    
//    NSLog(@"pan location: %f, %f", location.x, location.y);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
