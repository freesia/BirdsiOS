//
//  GameVC.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameVC.h"
#import "birdsAppDelegate.h"
#import "Bird.h"

#import "NSMutableArray+Shuffle.h"


@implementation GameVC

@synthesize updateTimer;
@synthesize playButton;
@synthesize player;
@synthesize tableV;
@synthesize isImageOn;
@synthesize numberRounds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myArray=[[NSMutableArray alloc] init];
        birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
        for (int i=0; i<appDelegate.animals.count; i++) {
            Bird *animal = (Bird *)[appDelegate.animals objectAtIndex:i];
            [myArray addObject:animal];
        }

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
    self.navigationItem.title=@"Quiz";
    answers=[[NSMutableArray alloc]init];
    listOfMusic=[[NSMutableArray alloc] init];
    ///init AudioPlayerControls
    
    playBtnBG = [UIImage imageNamed:@"play.png"];
	pauseBtnBG = [UIImage imageNamed:@"pause.png"];
    [playButton setImage:playBtnBG forState:UIControlStateNormal];
    numberOfRounds=0;
    numberOfRightAnswers=0;
    [self refreshScreen];
   
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) viewDidDisappear:(BOOL)animated {
    [player stop];
    int piul =round((numberOfRightAnswers/numberOfRounds)*100.0);
    NSString *piu =[NSString stringWithFormat:@"Your result is %d %% right answers",piul];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Game Results" message:piu delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];

}
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return answers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier ";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellTableIdentifier]; 
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor=[UIColor colorWithRed:0.8902 green:.8902 blue:.7882 alpha:0.95];
    cell.textLabel.textColor=[UIColor brownColor];
    cell.textLabel.text=[answers objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell.textLabel.text isEqualToString:rightAnswer]) {
        [self hideControls];
        answerLabel.text=@"Right";
        [tableV setUserInteractionEnabled:NO];
        numberOfRightAnswers++;
        NSLog(@"%f", numberOfRightAnswers);
        double piu =(numberOfRightAnswers/numberOfRounds)*100.0;
        NSLog(@"%f", piu);
        [player stop];
        selectedCell.textLabel.textColor=[UIColor colorWithRed:.4706 green:.6353 blue:.1843 alpha:1.0];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(refreshScreen)
                                       userInfo:nil
                                        repeats:NO];
        
    } else {
        [self hideControls];
        answerLabel.text=@"Wrong";
        [tableV setUserInteractionEnabled:NO];
        [player stop];
        selectedCell.textLabel.textColor=[UIColor redColor];
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(refreshScreen)
                                       userInfo:nil
                                        repeats:NO];
       
    }
}
#pragma mark -
#pragma mark Actions

-(void)updateProgress 
{
    
    float x= 1-(player.currentTime/player.duration);
    trackProgress.progress = x;
    [self updateTime];
    
}
-(void)updateTime
{
    float minutes = floor(player.currentTime/60);
    float seconds = player.currentTime - (minutes * 60);
    
    float duration_minutes = floor(player.duration/60);
    float duration_seconds = 
    player.duration - (duration_minutes * 60);
    
    NSString *timeInfoString = [[NSString alloc] 
                                initWithFormat:@"%0.0f.%0.0f / %0.0f.%0.0f",
                                minutes, seconds, 
                                duration_minutes, duration_seconds];
    
    timeLabel.text = timeInfoString;
}
-(void)hideControls {
    [timeLabel setHidden:YES];
    [trackProgress setHidden:YES];
    [playButton setHidden:YES];
        
    [answerLabel setHidden:NO];

}
-(void)showControls {
    [timeLabel setHidden:NO];
    [trackProgress setHidden:NO];
    [playButton setHidden:NO];
    
    [answerLabel setHidden:YES];
}


#pragma mark -
#pragma mark AudioPlayer 
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
- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	
    
	if (updateTimer) 
		[updateTimer invalidate];
    
	if (p.playing)
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
       updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateProgress) userInfo:p repeats:YES];
	}
	else
	{
		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
        updateTimer = nil;
	}
	
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
    
	[p setCurrentTime:0.];
    [self updateViewForPlayerState:p];
    
}

#pragma mark - 
#pragma mark Refreshing Screen 
-(void)refreshScreen {
    [tableV setUserInteractionEnabled:YES];
    [self showControls];
    [listOfMusic removeAllObjects];
    [answers removeAllObjects];
    if (numberOfRounds<numberRounds) {
    numberOfRounds++;
    int num = round(numberOfRounds);  
    roundLabel.text=[NSString stringWithFormat:@"Round %d", num];
    
    ///init Right Answer Bird
    int r = arc4random() % [myArray count];
    Bird *bird =[myArray objectAtIndex:r];
    if (isImageOn) {
        birdImage.image=[UIImage imageNamed:bird.image];
    } else {
        birdImage.image=[UIImage imageNamed:@"icon_quiz_inactive.png"];
    }
    rightAnswer=bird.name;
    [answers addObject:rightAnswer];
   
    if (![bird.shortSound isEqualToString:@""]) {
        [listOfMusic addObject:bird.shortSound];
        }
    if (![bird.long_sound isEqualToString:@""]) {
        [listOfMusic addObject:bird.long_sound];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:[listOfMusic objectAtIndex:0]  ofType:@""];  
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];   
    player.delegate = self;   
    
    if (self.player) {
        //  [self updateViewForPlayerInfo:player];
		[self updateViewForPlayerState:player];
    }
    updateTimer = nil;
    [self playButtonPressed:playButton];
    
    //init Wrong answers
    int wr1=arc4random() % [myArray count];
    int wr2=arc4random() % [myArray count];
    
    Bird *wrongBird =[myArray objectAtIndex:wr1];
    Bird *wrongBird2 =[myArray objectAtIndex:wr2];
    [answers addObject:wrongBird.name];
    [answers addObject:wrongBird2.name];
    
    [answers shuffle];
    
    [self.tableV reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
