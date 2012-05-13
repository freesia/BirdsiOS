//
//  DetailTabController.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"


@class AlphabetViewController;

@interface DetailTabController : UIViewController   <FBSessionDelegate,FBDialogDelegate> {
    IBOutlet  UITabBarController *tabBar;
    
    NSString *name;
    NSString *speciesName;
    int iD;
    NSString *shortSound;
    NSString *long_sound;
    NSString *image;
    NSString *text;
    int sight;
    AlphabetViewController *delegate;
    
    NSArray* _permissions;
}


@property (nonatomic)  AlphabetViewController *delegate;
@property (nonatomic) int sight;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *speciesName;
@property (nonatomic) int Id;
@property (nonatomic) NSString *shortSound;
@property (nonatomic) NSString *long_sound;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *text;

- (void)share;


@end
