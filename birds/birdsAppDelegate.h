//
//  birdsAppDelegate.h
//  birds
//
//  Created by Katie on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Facebook.h"


@interface birdsAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    NSMutableArray *animals;
    NSMutableArray *birdLocations;
    Facebook *facebook;
    
    // Database variables
	NSString *databaseName;
	NSString *databasePath;
    
   
}


@property (nonatomic) IBOutlet UIWindow *window;

@property (nonatomic) IBOutlet UINavigationController *navigationController;

@property (nonatomic) NSMutableArray *animals;
@property (nonatomic) NSMutableArray *birdLocations;

@property (nonatomic) Facebook *facebook;

-(void) readAnimalsFromDatabase;
-(void) checkAndCreateDatabase;
-(void) readBirdsLocationsFromDatabase;
@end
