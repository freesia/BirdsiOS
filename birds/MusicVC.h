//
//  MusicVC.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTabController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MusicVC : UIViewController <UITableViewDataSource, UITableViewDelegate,AVAudioPlayerDelegate>{

    IBOutlet UILabel *nameLabel;
    IBOutlet UIImageView *mage;
    IBOutlet UIView *volumeView;
 
    
    IBOutlet UIView *bigImageView;
    IBOutlet UIImageView *bigImage;

    //audioControls
    
    IBOutlet UIToolbar  *volume;
    IBOutlet UISlider   *volumeSlider;
    IBOutlet UIButton	*playButton;
	IBOutlet UIButton	*ffwButton;
	IBOutlet UIButton	*rewButton;
    IBOutlet UILabel	*currentTime;
	IBOutlet UILabel	*duration;
    
    UIImage				*playBtnBG;
	UIImage				*pauseBtnBG;
	NSTimer				*updateTimer;
	NSTimer				*rewTimer;
	NSTimer				*ffwTimer;
    
    DetailTabController *detailVC;
    NSMutableArray *listOfMusic;
    
    AVAudioPlayer	*player;
    NSTimer *timer;
}
@property (nonatomic)	AVAudioPlayer	*player;
@property (nonatomic)  DetailTabController *detailVC;
@property (nonatomic)	UIButton		*playButton;
@property (nonatomic)	UIButton		*ffwButton;
@property (nonatomic)	UIButton		*rewButton;
@property (nonatomic)	UISlider		*volumeSlider;
@property (nonatomic)	UILabel			*currentTime;
@property (nonatomic)	NSTimer			*updateTimer;


@property (nonatomic)	UILabel			*duration;


- (IBAction)zoomButtonPressed;
- (IBAction)addVolumeView;
- (IBAction)cancelButtonPressed;
- (IBAction)zoomOutButtonPressed;

//audioControls
- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonPressed:(UIButton*)sender;
- (IBAction)rewButtonReleased:(UIButton*)sender;
- (IBAction)ffwButtonPressed:(UIButton*)sender;
- (IBAction)ffwButtonReleased:(UIButton*)sender;
- (IBAction)volumeSliderMoved:(UISlider*)sender;
@end
