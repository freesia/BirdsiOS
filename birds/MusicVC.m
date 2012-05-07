//
//  MusicVC.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MusicVC.h"
// amount to skip on rewind or fast forward
#define SKIP_TIME 1.0			
// amount to play between skips
#define SKIP_INTERVAL .2

void RouteChangeListener(	void *                  inClientData,
                         AudioSessionPropertyID	inID,
                         UInt32                  inDataSize,
                         const void *            inData);

@implementation MusicVC

@synthesize detailVC;
@synthesize playButton;
@synthesize ffwButton;
@synthesize rewButton;
@synthesize volumeSlider;
@synthesize currentTime;
@synthesize updateTimer;
@synthesize player;
@synthesize duration;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    nameLabel.text=detailVC.name;
    mage.image=[UIImage imageNamed:detailVC.image];
  
    bigImage.image=[UIImage imageNamed:detailVC.image];
   
    //init array of music
    listOfMusic=[[NSMutableArray alloc] init];
    if (![detailVC.shortSound isEqualToString:@""]) {
        [listOfMusic addObject:detailVC.shortSound];
    }
    if (![detailVC.long_sound isEqualToString:@""]) {
        [listOfMusic addObject:detailVC.long_sound];
    }
    ///init VIews
    bigImageView.frame=CGRectMake(0, -44, 320,436);
    [self.view addSubview:bigImageView];
    [bigImageView setHidden:YES];
    
    ///init AudioPlayer
    NSString *path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:[listOfMusic objectAtIndex:0]];   
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];   
    player.delegate = self;   
    duration.adjustsFontSizeToFitWidth = YES;
	currentTime.adjustsFontSizeToFitWidth = YES;
    if (self.player) {
        [self updateViewForPlayerInfo:player];
		[self updateViewForPlayerState:player];
    }
    OSStatus result = AudioSessionInitialize(NULL, NULL, NULL, NULL);
	if (result)
		NSLog(@"Error initializing audio session! %ld", result);
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
			
	result = AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, RouteChangeListener, (__bridge void *)(self));
	if (result) 
		NSLog(@"Could not add property listener! %ld", result);


    ///init AudioPlayerControls
    playBtnBG = [UIImage imageNamed:@"play.png"];
	pauseBtnBG = [UIImage imageNamed:@"pause.png"];
    [playButton setImage:playBtnBG forState:UIControlStateNormal];
    
    updateTimer = nil;
	rewTimer = nil;
	ffwTimer = nil;
    [volume setHidden:YES];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    [player stop];
   
}
- (void)loadView {
    [super loadView];
 
}
- (void) viewWillDisappear:(BOOL)animated {
    [player stop];
}
#pragma mark -
#pragma mark Actions
- (IBAction)zoomButtonPressed {
    [bigImageView setHidden:NO];
    
}
- (IBAction)zoomOutButtonPressed {
    [bigImageView setHidden:YES];

}


#pragma mark -
#pragma TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listOfMusic count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier ";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellTableIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    }
    cell.backgroundColor=[UIColor colorWithRed:0.8902 green:.8902 blue:.7882 alpha:0.95];
    cell.textLabel.textColor=[UIColor brownColor];
    cell.textLabel.text=[listOfMusic objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![player isPlaying]) {
        NSString *path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:[listOfMusic objectAtIndex:indexPath.row]];   
        player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
        if (self.player) {
            [self updateViewForPlayerInfo:player];
            [self updateViewForPlayerState:player];
        }
        [self playButtonPressed:playButton];
    }
 
}

#pragma mark -
#pragma mark View Add/delete from screen

-(IBAction)cancelButtonPressed {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    volume.frame = CGRectMake(0, 392, 320, 44);
    
    [UIView commitAnimations];
    [volume setHidden:YES];
}

-(IBAction)addVolumeView {
    

    
    [self.view becomeFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    volume.frame = CGRectMake(0,300, 320,44);
    [volume setHidden:NO];
    [UIView commitAnimations];
    
}

#pragma mark - 
#pragma mark AudioPlayer Methods
-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
	
}

- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.player];
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
    
	if (updateTimer) 
		[updateTimer invalidate];
    
	if (p.playing)
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
         updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}
	else
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
		 updateTimer = nil;
	}
	
}

-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
	duration.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
    volumeSlider.value = p.volume;
}

- (void)rewind
{
	AVAudioPlayer *p = rewTimer.userInfo;
	p.currentTime-= SKIP_TIME;
	[self updateCurrentTimeForPlayer:p];
}

- (void)ffwd
{
	AVAudioPlayer *p = ffwTimer.userInfo;
	p.currentTime+= SKIP_TIME;	
	[self updateCurrentTimeForPlayer:p];
}
#pragma mark AudioSession handlers

void RouteChangeListener(	void *                  inClientData,
                         AudioSessionPropertyID	inID,
                         UInt32                  inDataSize,
                         const void *            inData)
{
	//avTouchController* This = (avTouchController*)inClientData;
	
	if (inID == kAudioSessionProperty_AudioRouteChange) {
		
		CFDictionaryRef routeDict = (CFDictionaryRef)inData;
		NSNumber* reasonValue = (__bridge NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		
		int reason = [reasonValue intValue];
        
		if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
		//	[self pausePlaybackForPlayer:self.player];
		}
	}
}

#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
    
	[p setCurrentTime:0.];
    [self updateViewForPlayerState:p];

}

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
	[self updateViewForPlayerState:p];
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p
{
	if ([p play])
	{
		[self updateViewForPlayerState:p];
	}
	else
		NSLog(@"Could not play %@\n", p.url);
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
	if (player.playing == YES)
		[self pausePlaybackForPlayer: player];
	else
		[self startPlaybackForPlayer: player];
}

- (IBAction)rewButtonPressed:(UIButton *)sender
{
	if (rewTimer) [rewTimer invalidate];
	rewTimer = [NSTimer scheduledTimerWithTimeInterval:SKIP_INTERVAL target:self selector:@selector(rewind) userInfo:player repeats:YES];
}

- (IBAction)rewButtonReleased:(UIButton *)sender
{
	if (rewTimer) [rewTimer invalidate];
	rewTimer = nil;
}

- (IBAction)ffwButtonPressed:(UIButton *)sender
{
	if (ffwTimer) [ffwTimer invalidate];
	ffwTimer = [NSTimer scheduledTimerWithTimeInterval:SKIP_INTERVAL target:self selector:@selector(ffwd) userInfo:player repeats:YES];
}

- (IBAction)ffwButtonReleased:(UIButton *)sender
{
	if (ffwTimer) [ffwTimer invalidate];
	ffwTimer = nil;
}

- (IBAction)volumeSliderMoved:(UISlider *)sender
{
	player.volume = [sender value];
}

- (IBAction)progressSliderMoved:(UISlider *)sender
{
	player.currentTime = sender.value;
	
}


@end
