//
//  GameOptionsViewController.h
//  birds
//
//  Created by Katie on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameVC.h"


@interface GameOptionsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource> {
   
    GameVC *gameVC;
    
    
    NSArray *dataSource;
    NSArray *detailLabels;
    NSString *selected;
    int flag;
    UITableView *tableV;
    UISwitch *switcher;
    
    IBOutlet UIView *dataPickerView;
    IBOutlet UIPickerView *picker;
    NSString *numberOfRounds;
    
    NSDictionary *names;
    NSArray     *keys;
    
    BOOL isImageEnabled;
    int numOfRounds;
   }
@property (nonatomic) NSDictionary *names; 
@property (nonatomic) NSArray *keys;

@property (nonatomic)  IBOutlet UITableView *tableV;
-(IBAction) switchValueChanged;
-(IBAction)startButtonPressed;
-(IBAction)doneButtonPressed;
-(IBAction)cancelButtonPressed;
-(void)addPickerView;

@end
