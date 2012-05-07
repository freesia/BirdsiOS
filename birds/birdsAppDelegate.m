//
//  birdsAppDelegate.m
//  birds
//
//  Created by Katie on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "birdsAppDelegate.h"
#import "Bird.h"
#import "DetailTabController.h"
#import "BirdAnnotation.h"

@implementation birdsAppDelegate


@synthesize window;

@synthesize navigationController;
@synthesize animals;
@synthesize facebook;
@synthesize birdLocations;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   

    // Setup some globals
	databaseName = @"bidrs.sql";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	[self readAnimalsFromDatabase];
    [self checkAndCreateDatabase];
    [self readBirdsLocationsFromDatabase];
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    
    self.window.rootViewController = self.navigationController;
    [application setStatusBarHidden:YES withAnimation:NO];
    navigationController.navigationBarHidden=YES;
    
    [self.window makeKeyAndVisible];
    facebook = [[Facebook alloc] initWithAppId:@"309823785757178" andDelegate:self];
    if (!309823785757178) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",@"309823785757178"];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
        }
    }
    
    return YES;
}
// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - 
#pragma mark Facebook
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults synchronize];
    
}

#pragma mark - 
#pragma mark Database Methods

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
}

-(void) readAnimalsFromDatabase {
	// Setup the database object
	sqlite3 *database;
	
	// Init the animals Array
	animals = [[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from birds";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aSpecies = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *aShortSound;
                NSString *aLongSound; 
                if (sqlite3_column_text(compiledStatement, 3) != nil) {
                    aShortSound = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                } else {
                    aShortSound=@"";
                }
				if (sqlite3_column_text(compiledStatement, 4) != nil) {
                    aLongSound = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                } else {
                    aLongSound=@"";
                }
                
                NSString *aImage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *aText=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				
				// Create a new animal object with the data from the database
				Bird *bird = [[Bird alloc] initWithName:aName speciesName:aSpecies image:aImage text:aText shortSound:aShortSound longSound:aLongSound];
				
				// Add the animal object to the animals Array
				[animals addObject:bird];
				
			}
		}
	//sqlite3_finalize(compiledStatement);
		
	}
	
	
}
-(void) readBirdsLocationsFromDatabase {
	// Setup the database object
	sqlite3 *database;
	
	// Init the animals Array
	birdLocations = [[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from loc";
		sqlite3_stmt *compiledStatement2;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement2, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement2) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aLongtitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 1)];
				NSString *aLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 2)];
                NSString *aName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 3)];
                NSString *aSpeciesName =[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 0)];
                				
				// Create a new animal object with the data from the database
				BirdAnnotation *birdAnotation =[[BirdAnnotation alloc] initWithName:aName longtitude:aLongtitude latitude:aLatitude speciesName:aSpeciesName];
				
				// Add the animal object to the animals Array
				[birdLocations addObject:birdAnotation];
				
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement2);
		
	}
	sqlite3_close(database);
	
}
@end
