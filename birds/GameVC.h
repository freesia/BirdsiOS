//
//  GameVC.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <stdlib.h>




@interface GameVC : UIViewController  <UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate,UINavigationControllerDelegate>{
    IBOutlet UILabel        *timeLabel;
    IBOutlet UIProgressView *trackProgress;
    IBOutlet UIButton       *playButton;
    IBOutlet UIImageView    *birdImage;
    IBOutlet UILabel        *roundLabel;
    IBOutlet UILabel        *answerLabel;
    
    UITableView             *tableV;
    AVAudioPlayer           *player;
    NSTimer                 *timer;
    NSMutableArray          *answers;
    NSMutableArray          *listOfMusic;
    
    int answer;
    NSString *rightAnswer;
    NSMutableArray *myArray;
    
    
   	NSTimer				*updateTimer;
    UIImage				*playBtnBG;
	UIImage				*pauseBtnBG;
    
    double              numberOfRounds;
    double              numberOfRightAnswers;
    
    BOOL                isImageOn;
    int                 numberRounds;
    
}
@property (nonatomic, assign)   BOOL            isImageOn;
@property (nonatomic, assign)   int             numberRounds;


@property (nonatomic)	UIButton		*playButton;
@property (nonatomic)	NSTimer			*updateTimer;
@property (nonatomic)   AVAudioPlayer   *player;
@property (nonatomic)   IBOutlet UITableView    *tableV;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (void)updateProgress; 
- (void)updateTime;

-(void)hideControls;
-(void)showControls;
-(void)refreshScreen;

@end
