//
//  ViewController.m
//  Maps
//
//  Created by Christopher Cohen on 3/4/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"

@interface ViewController ()

#define METERS_PER_MILE 1609.344
@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) NSMutableArray *locationArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myMapView.delegate = self;
    
    _locationArray = [NSMutableArray new];
    
    _myMapView = [[MKMapView alloc]   initWithFrame:self.view.frame];
    [self.view addSubview:_myMapView];
    
    CLLocationCoordinate2D someLocation;
    
    someLocation.latitude = 47.6097;
    someLocation.longitude = -122.3331;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(someLocation, 3*METERS_PER_MILE, 3*METERS_PER_MILE);
    
    [_myMapView setRegion:viewRegion animated:YES];
    
    [self downloadTechCompanies];
    
    [self backGroundImage:@"MapFG.png"];
    [self displayHeaderText:@"Tech Companies in Seattle"];

	// Do any additional setup after loading the view, typically from a nib.
}
-(void)downloadTechCompanies
{
    NSString *searchString  = [NSString stringWithFormat:@"https://opendata.socrata.com/resource/mg7b-2utv.json"];
    NSURL *searchURL        = [NSURL URLWithString:searchString];
    NSData *searchData      = [NSData dataWithContentsOfURL:searchURL];
    NSError *error;
    
    NSArray *techArray      = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"My array: %@", techArray);
    
    for (NSDictionary *dictionary in techArray) {
        Location *newLocation = [Location new];
        newLocation.ceo = [dictionary objectForKey:@"ceo"];
        newLocation.name = [dictionary objectForKey:@"company_name"];
        
        NSDictionary *location = [dictionary objectForKey:@"location"];
        //newLocation.address = [location objectForKey:@"human_address"];
        
        newLocation.address = [self formatAddress:[location objectForKey:@"human_address"]];
        
        CLLocationCoordinate2D tempCoordinate;
        
        tempCoordinate.latitude = [[location objectForKey:@"latitude"] doubleValue];
        tempCoordinate.longitude = [[location objectForKey:@"longitude"] doubleValue];
        
        newLocation.coordinate = CLLocationCoordinate2DMake(tempCoordinate.latitude, tempCoordinate.longitude);

        [_locationArray addObject:newLocation];
        [self.myMapView addAnnotation:newLocation];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[Location class]]){
        MKAnnotationView *annotationView = (MKAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backGroundImage:(NSString *)imageName
{
    UIImageView *wallPaper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [wallPaper setFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:wallPaper];
    [self.view insertSubview:wallPaper atIndex: 10];
}

- (NSString *)formatAddress:(NSString *)address
{
    //Formatting Marks
    address = [address stringByReplacingOccurrencesOfString:@"{"            withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"}"            withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"\""           withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@":"            withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"."            withString:@""];

    //Remove Unwanted Strings
    address = [address stringByReplacingOccurrencesOfString:@"address"      withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"city"         withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"state"        withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"zip"          withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"Seattle,"     withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"WA,"          withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"seattle,"     withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"wa,"          withString:@""];

    //Abreviate Overlong Strings
    address = [address stringByReplacingOccurrencesOfString:@"Suite "       withString:@"#"];
    address = [address stringByReplacingOccurrencesOfString:@"Ste "         withString:@"#"];
    address = [address stringByReplacingOccurrencesOfString:@"STE "         withString:@"#"];
    address = [address stringByReplacingOccurrencesOfString:@"Avenue"       withString:@"Ave"];
    address = [address stringByReplacingOccurrencesOfString:@"AVE"          withString:@"Ave"];
    address = [address stringByReplacingOccurrencesOfString:@"First"        withString:@"1st"];
    address = [address stringByReplacingOccurrencesOfString:@"Second"       withString:@"2nd"];
    address = [address stringByReplacingOccurrencesOfString:@"Third"        withString:@"3rd"];
    address = [address stringByReplacingOccurrencesOfString:@"Fourth"       withString:@"4th"];
    address = [address stringByReplacingOccurrencesOfString:@"Fifth"        withString:@"5th"];
    address = [address stringByReplacingOccurrencesOfString:@"Sixth"        withString:@"6th"];
    address = [address stringByReplacingOccurrencesOfString:@"Seventh"      withString:@"7th"];
    address = [address stringByReplacingOccurrencesOfString:@"Eighth"       withString:@"8th"];
    address = [address stringByReplacingOccurrencesOfString:@"Ninth"        withString:@"9th"];
    address = [address stringByReplacingOccurrencesOfString:@"Tenth"        withString:@"10th"];
    address = [address stringByReplacingOccurrencesOfString:@"South"        withString:@"S"];
    address = [address stringByReplacingOccurrencesOfString:@"North"        withString:@"N"];
    
    //Post Edit Cleanup
    address = [address stringByReplacingOccurrencesOfString:@","            withString:@", "];
    address = [address stringByReplacingOccurrencesOfString:@" ,"           withString:@","];
    address = [address stringByReplacingOccurrencesOfString:@"  "           withString:@" "];

    return address;
}

- (void)displayHeaderText:(NSString *)text
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    header.text = text;
    header.textColor = [UIColor whiteColor];
    [header setShadowColor:[UIColor blackColor]];
    [header setShadowOffset:CGSizeMake(0, 2)];

    [header setFont: [UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:header];
}


@end
