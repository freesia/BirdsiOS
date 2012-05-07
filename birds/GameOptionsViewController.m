//
//  GameOptionsViewController.m
//  birds
//
//  Created by Katie on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOptionsViewController.h"
#import "SwitcherCellVC.h"

#import "birdsAppDelegate.h"
#import "GameVC.h"



@implementation GameOptionsViewController

@synthesize names, keys;
@synthesize tableV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
 
    self.navigationItem.title = @"Trainer";
    ////reading info from file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameOptions"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    self.names = dict;
    NSArray *array = [names allKeys];
    self.keys = array;
    ////Add Picker View
    dataSource=[[NSArray alloc]init];
    dataPickerView.frame=CGRectMake(0, 1000, 320, 260);
   
    numberOfRounds=[[NSString alloc] initWithString:@"15"];
    isImageEnabled=YES;
    
    [self.view addSubview:dataPickerView];
}

-(void)viewWillAppear:(BOOL)animated {
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.names = nil;
    self.keys = nil;
   
}
- (void) viewDidAppear:(BOOL)animated {
   
    [self.tableV reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
   
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark TableViewDaraSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        static NSString *CellTableIdentifier = @"CellTableIdentifier ";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:CellTableIdentifier];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        switcher=[[UISwitch alloc] initWithFrame:CGRectMake(221, 8, 79, 27)];
        switcher.onTintColor=[UIColor colorWithRed:.4706 green:.6353 blue:.1843 alpha:1.0];
        [switcher setOn:YES];
        [switcher addTarget:self action:(@selector(switchValueChanged)) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switcher];
        cell.backgroundColor=[UIColor colorWithRed:0.8902 green:.8902 blue:.7882 alpha:0.95];
        cell.textLabel.textColor=[UIColor brownColor];
        cell.textLabel.text=@"View image";
       
        return cell;
    }
    else {
        static NSString *CellTableIdentifier = @"CellTableIdentifier ";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleValue1
                     reuseIdentifier:CellTableIdentifier];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        cell.backgroundColor=[UIColor colorWithRed:0.8902 green:.8902 blue:.7882 alpha:0.95];
        cell.textLabel.textColor=[UIColor brownColor];
        cell.textLabel.text=[keys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=numberOfRounds;
        return cell;
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
#pragma mark -
#pragma TableView DElegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<1) {
        NSString *key=[keys objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
            case 0:
             
                dataSource= [names objectForKey:key];
                [self addPickerView];
                break;
       
            default:
             
                break;
        }
    }
}

#pragma mark -
#pragma mark Actions
-(IBAction) switchValueChanged{
    if (switcher.on) {
        isImageEnabled=YES;
        NSLog(@"%d",isImageEnabled);
    }
    
    else {  
        isImageEnabled=NO;
        NSLog(@"%d",isImageEnabled);
    }
    
}


-(IBAction)startButtonPressed {
    gameVC=[[GameVC alloc] initWithNibName:@"GameVC" bundle:nil];
    birdsAppDelegate *delegate = (birdsAppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([numberOfRounds isEqualToString:@"Unlimited"]) {
        numOfRounds=9000;
        } else {
          numOfRounds=[numberOfRounds intValue];
    }
    gameVC.isImageOn=isImageEnabled;
    gameVC.numberRounds=numOfRounds;
    [delegate.navigationController pushViewController:gameVC animated:YES];
}

-(IBAction)doneButtonPressed {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    dataPickerView.frame = CGRectMake(0, 1000, 320, 260);
    [UIView commitAnimations];
    NSInteger row = [picker selectedRowInComponent:0];
    selected = [dataSource objectAtIndex:row];
    numberOfRounds=selected;
    [self.tableV reloadData];
 
}
-(IBAction)cancelButtonPressed {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    dataPickerView.frame = CGRectMake(0, 1000, 320, 260);
    [UIView commitAnimations];}

-(void)addPickerView {
    
    [self.view becomeFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    dataPickerView.frame = CGRectMake(0, 176, self.view.frame.size.width, self.view.frame.size.height);
    picker.dataSource = self;
    picker.delegate = self;
    [UIView commitAnimations];
    
}
#pragma mark -
#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [dataSource objectAtIndex:row];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataSource count];
}
@end
