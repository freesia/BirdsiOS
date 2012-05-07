//
//  DesciptionVC.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DesciptionVC.h"

@implementation DesciptionVC
@synthesize detailVC;

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
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    nameLabel.text=detailVC.name;
    speciesLabel.text=detailVC.speciesName;
    image.image=[UIImage imageNamed:detailVC.image];
    bigImage.image=[UIImage imageNamed:detailVC.image];
    NSString *name =[detailVC.text stringByReplacingOccurrencesOfString:@".txt" withString:@""];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];  
    if (filePath) {  
        NSError *error;
        NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error]; 
        
        if (myText) {  
            text.text= myText;  
        }  
    }  
    ///init VIews
    bigImageView.frame=CGRectMake(0, -44, 320,436);
    [self.view addSubview:bigImageView];
    [bigImageView setHidden:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
  
}

#pragma mark -
#pragma mark Actions
- (IBAction)zoomButtonPressed {
    [bigImageView setHidden:NO];
    
}
- (IBAction)zoomOutButtonPressed {
    [bigImageView setHidden:YES];
    
}

@end
