//
//  Location.h
//  Maps
//
//  Created by Christopher Cohen on 3/4/14.
//  Copyright (c) 2014 Christopher Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>

@interface Location : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *ceo;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;



@end
