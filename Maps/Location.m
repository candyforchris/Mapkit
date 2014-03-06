//
//  Location.m
//  Maps
//
//  Created by Christopher Cohen on 3/4/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import "Location.h"
#import <AddressBook/AddressBook.h>

@implementation Location

-(NSString *)title {
    return _name;
}

-(NSString *)subtitle {
    
    return _address;
}

-(CLLocationCoordinate2D)coordinate {
    return _coordinate;
}


-(MKMapItem *)mapItem
{
    NSDictionary *addressDictionary = @{(NSString *)kABPersonAddressStreetKey: _address};
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:_coordinate addressDictionary:addressDictionary];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mapItem;
}

@end
