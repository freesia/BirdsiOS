//
//  RootViewController.h
//  birds
//
//  Created by Katie on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameOptionsViewController.h"
#import "AboutViewController.h"
#import "AlphabetViewController.h"
#import "MapViewController.h"

@interface RootViewController : UIViewController <UINavigationControllerDelegate>{
    GameOptionsViewController *trainerViewController;
    AboutViewController *aboutVC;
    AlphabetViewController *alphabetVC;
    MapViewController *mapVC;
    UINavigationBar *navBar;
}
@property (nonatomic) UINavigationBar *navBar;
-(IBAction)trainerButtonPressed;
-(IBAction)aboutButtonPressed:(id)sender;
-(IBAction)listButtonPressed:(id)sender;
-(IBAction)mapButtonPressed:(id)sender;

@end
