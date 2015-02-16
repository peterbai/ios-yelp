//
//  DetailViewController.m
//  Yelp
//
//  Created by Peter Bai on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import <MapKit/MapKit.h>

@interface DetailViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurredImageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];

    [self initiateLayoutFromBusinessData];
    self.businessImageView.alpha = 0.5;
    
    self.mapView.delegate = self;
    [self addAnnotationAndSetRegion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom setters

- (void)setBusiness:(CPBusiness *)business {
    _business = business;
    [self initiateLayoutFromBusinessData];
}

#pragma mark Private methods

- (void)initiateLayoutFromBusinessData {
    
    NSURLRequest *requestImageSmall = [NSURLRequest requestWithURL:[NSURL URLWithString:self.business.smallImageURL]];
//    NSURLRequest *requestImageLarge = [NSURLRequest requestWithURL:[NSURL URLWithString:self.business.largeImageURL]];
    
    // load small image, then replace with large image
    [self.businessImageView setImageWithURLRequest:requestImageSmall
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               [UIView transitionWithView:self.businessImageView
                                                                 duration:0.3
                                                                  options:UIViewAnimationOptionTransitionCrossDissolve
                                                               animations:^{
                                                                   self.businessImageView.image = [image blurredImageWithRadius:10.0 iterations:1.0 tintColor:[UIColor whiteColor]];
                                                               } completion: nil];
                                               
                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               NSLog(@"Error retrieving small image: %@", error);
                                           }];
    
    /*
     [self.businessImageView setImageWithURLRequest: requestImageLarge
     placeholderImage: nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
     [UIView transitionWithView:self.businessImageView
     duration:0.3
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^{
     self.businessImageView.image = [image blurredImageWithRadius:10.0 iterations:1.0 tintColor:nil];
     } completion: nil];
     
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
     NSLog(@"Error retrieving large image: %@", error);
     }];
     */
    
    self.nameLabel.text = self.business.name;
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", (long)self.business.numReviews];
    self.addressLabel.text = self.business.fullAddress;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    self.categoryLabel.text = self.business.categories;
}

- (void)onSearchButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Mapping methods

- (void)addAnnotationAndSetRegion {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.business.locationLatitude, self.business.locationLongitude);
    annotation.title = self.business.name;
    annotation.subtitle = self.business.categories;
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.business.locationLatitude;
    newRegion.center.longitude = self.business.locationLongitude;
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:newRegion animated:YES];
}

@end
