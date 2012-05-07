//
//  RootViewController.m
//  birds
//
//  Created by Katie on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "AboutViewController.h"
#import "AlphabetViewController.h"


@implementation RootViewController
@synthesize navBar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Start";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
 
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

#pragma mark -
#pragma mark Actions
-(IBAction)trainerButtonPressed {
    trainerViewController=[[GameOptionsViewController alloc]initWithNibName:@"GameOptionsViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationItem.hidesBackButton=NO;
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:.4705 green:.6353 blue:.1843 alpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController pushViewController:trainerViewController animated:YES];
 
}

-(IBAction)aboutButtonPressed:(id)sender {
    aboutVC=[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationItem.hidesBackButton=NO;
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:.4705 green:.6353 blue:.1843 alpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController pushViewController:aboutVC animated:YES];

}
-(IBAction)listButtonPressed:(id)sender {
    alphabetVC=[[AlphabetViewController alloc]initWithNibName:@"AlphabetViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationItem.hidesBackButton=NO;
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:.4705 green:.6353 blue:.1843 alpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController pushViewController:alphabetVC animated:YES];
 
}
-(IBAction)mapButtonPressed:(id)sender {
    mapVC=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationItem.hidesBackButton=NO;
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:.4705 green:.6353 blue:.1843 alpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController pushViewController:mapVC animated:YES];
}
@end
