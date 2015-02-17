//
//  MapViewController.m
//  Yelp
//
//  Created by Peter Bai on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MapViewController.h"
#import "CPBusiness.h"
#import "DetailViewController.h"
#import "BusinessAnnotation.h"
#import "AppDelegate.h"
#import "FiltersViewController.h"

@interface MapViewController () <MKMapViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] locationManager] requestWhenInUseAuthorization];
    
    // Customize navigation bar
    [self setMainNavigationBarItems];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 210.0, 44.0)];
    self.searchBar.tintColor = [UIColor colorWithRed:57.0/255
                                               green:64.0/255
                                                blue:142.0/255
                                               alpha:1.0];
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.delegate = self;
    self.searchBar.text = self.searchTerm;
    self.navigationItem.titleView = self.searchBar;
    
    self.mapView.delegate = self;
    [self gotoLocation];
    [self addAnnotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Mapping methods

- (void)addAnnotations {
    for (CPBusiness *business in self.businesses) {
//        NSLog(@"lat: %f, long: %f", business.locationLatitude, business.locationLongitude);
        
        BusinessAnnotation *annotation = [[BusinessAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(business.locationLatitude, business.locationLongitude);
        annotation.title = business.name;
        annotation.subtitle = business.categories;
        annotation.business = business;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)gotoLocation {
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [[self.region valueForKeyPath:@"center.latitude"] doubleValue];
    newRegion.center.longitude = [[self.region valueForKeyPath:@"center.longitude"] doubleValue];
    newRegion.span.latitudeDelta = [[self.region valueForKeyPath:@"span.latitude_delta"] doubleValue];
    newRegion.span.longitudeDelta = [[self.region valueForKeyPath:@"span.longitude_delta"] doubleValue];
    [self.mapView setRegion:newRegion animated:YES];
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinAnnotation = nil;
    
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"myPin";
        pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if (pinAnnotation == nil) {
            pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        
        pinAnnotation.canShowCallout = YES;
        
        // Instantiate an info button on the right
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinAnnotation.rightCalloutAccessoryView = infoButton;
    }
    
    return pinAnnotation;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CPBusiness *business =[(BusinessAnnotation *)view.annotation business];
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.business = business;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark FiltersViewControllerDelegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"mapviewcontroller received method call from filtersviewcontroller");
    [self.delegate mapViewController:self search:self.searchTerm withFilters:filters inRegion:self.mapView.region];
}

#pragma mark Searchbar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchNavigationBarItems];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTerm = searchText;
    [self.delegate mapViewController:self setSearchTerm:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.delegate mapViewController:self search:self.searchTerm withFilters:nil inRegion:self.mapView.region];
    [self.searchBar resignFirstResponder];
    [self setMainNavigationBarItems];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self setMainNavigationBarItems];
}

#pragma mark Private methods

- (void)onFilterButton {
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onSearchButton {
    [self.delegate mapViewController:self search:self.searchTerm withFilters:nil inRegion:self.mapView.region];
}

- (void)onListButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setMainNavigationBarItems {
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(onListButton)];
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
@end
