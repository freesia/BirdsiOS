//
//  DetailTabController.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailTabController.h"
#import "MusicVC.h"
#import "DesciptionVC.h"
#import "birdsAppDelegate.h"
#import "SightingsVC.h"


static NSString* kAppId =  @"309823785757178";

@implementation DetailTabController

@synthesize name, speciesName,Id,image,text,shortSound,long_sound;
@synthesize delegate;
@synthesize sight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:tabBar.view];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                   target:self
                                                                                   action:@selector(share)]; 
    anotherButton.tintColor=[UIColor brownColor];
    
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    NSArray *tabBarItems = tabBar.viewControllers;
    DesciptionVC *descrVC= (DesciptionVC*) [tabBarItems objectAtIndex:1];
    MusicVC *musicVC= (MusicVC*) [tabBarItems objectAtIndex:0];
    SightingsVC *sightVC=(SightingsVC *) [tabBarItems objectAtIndex:2];
    
    sightVC.detailVC=self;
    musicVC.detailVC=self;
    descrVC.detailVC=self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fbDidLogin {
    birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[appDelegate.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[appDelegate.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}
- (void) share {
    birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![appDelegate.facebook isSessionValid]) {
        [appDelegate.facebook authorize:nil];
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"app_id",
                                   @"https://www.facebook.com/HoustonArboretum", @"link",
                                   
                                   name, @"name",
                                   speciesName, @"caption",
                                   @"I have seen this bird at Houston Arboretum", @"description",
                                   nil];
    
    [appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
}	
@end

