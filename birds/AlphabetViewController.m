//
//  AlphabetViewController.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlphabetViewController.h"

#import "DetailTabController.h"
#import "birdsAppDelegate.h"
#import "Bird.h"
#import "BirdCell.h"

@implementation AlphabetViewController

@synthesize table; 
@synthesize titles;
@synthesize tableData;
@synthesize dataSource;
@synthesize sBar;

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self readBirds];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
   
    [super didReceiveMemoryWarning];

}
-(void)readBirds{

    myArray=[[NSMutableArray alloc] init];
    arrayNames=[[NSMutableArray alloc]init];
    birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate readAnimalsFromDatabase];
    for (int i=0; i<appDelegate.animals.count; i++) {
        Bird *animal = (Bird *)[appDelegate.animals objectAtIndex:i];
        [myArray addObject:animal];
        [arrayNames addObject:animal.name];
    }
    copyListOfItems = [[NSMutableArray alloc] init];
    NSArray *objects = myArray;
    self.tableData = [self partitionObjects:objects collationStringSelector:@selector(name)];
    [self.table reloadData];
}

-(void)viewDidLoad {
    [super viewDidLoad];
   
    UISearchBar *temp = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    temp.translucent=YES;
    temp.tintColor=[UIColor brownColor];
    temp.showsCancelButton=YES;
    temp.autocorrectionType=UITextAutocorrectionTypeNo;
    temp.autocapitalizationType=UITextAutocapitalizationTypeNone;
    temp.delegate=self;
    table.tableHeaderView=temp;
    sBar=temp;
    self.navigationItem.title=@"All Birds";
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchIconButtonClicked)]; 
    anotherButton.tintColor=[UIColor brownColor];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    searching = NO;
    letUserSelectRow = YES;
    

    
  
}
- (void) viewDidAppear:(BOOL)animated {
    [self readBirds];
  
    [self.table reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [self hideSearchBar];
    self.table.scrollEnabled = YES;
    sBar.text = @"";
    [sBar resignFirstResponder];
    searching = NO;
    letUserSelectRow = YES;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchIconButtonClicked)]; 
    anotherButton.tintColor=[UIColor brownColor];
    self.navigationItem.rightBarButtonItem = anotherButton;

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searching)
        return 1;
    else {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching)
        return [copyListOfItems count];
    else {
    return [[self.tableData objectAtIndex:section] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(searching)
        return @"";
    BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
    return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"BirdCell";
    BirdCell *cell = (BirdCell *)[tableView
                                  dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if(searching){
  
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BirdCell"
                                                         owner:self options:nil];
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[BirdCell class]])
                    cell = (BirdCell *)oneObject;
        }
        
        NSString *selectedBird = [copyListOfItems objectAtIndex:indexPath.row];
        for (int i =0; i<myArray.count;i++) {
            Bird *bird=[myArray objectAtIndex:i];
            if ([selectedBird isEqualToString:bird.name]) {
                NSString *imageName = [bird.image stringByReplacingOccurrencesOfString:@".jpg" withString:@"_tn.jpg"];
                cell.birdImage.image=[UIImage imageNamed:imageName];
                
            }
        }

        cell.birdtitle.text = [copyListOfItems objectAtIndex:indexPath.row];
        
    }
    else {
    Bird *object = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    

  
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BirdCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[BirdCell class]])
                cell = (BirdCell *)oneObject;
    }
   
    cell.birdtitle.text=object.name;
    cell.birdDiscr.text=object.speciesName;
    cell.sightLabel.text= [NSString stringWithFormat:@"%d", object.sight];
    NSString *imageName = [object.image stringByReplacingOccurrencesOfString:@".jpg" withString:@"_tn.jpg"];
    cell.birdImage.image=[UIImage imageNamed:imageName];
    }
	return cell;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
   
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(searching) {
        NSString *selectedBird = [copyListOfItems objectAtIndex:indexPath.row];
        for (int i =0; i<myArray.count;i++) {
            Bird *bird=[myArray objectAtIndex:i];
            if ([selectedBird isEqualToString:bird.name]) {
                detailVC=[[DetailTabController alloc] initWithNibName:@"DetailTabController" bundle:nil];
                
                detailVC.image=bird.image;
                detailVC.name=bird.name;
                detailVC.speciesName=bird.speciesName;
                detailVC.text=bird.text;
                detailVC.shortSound=bird.shortSound;
                detailVC.long_sound=bird.long_sound;
                detailVC.sight=bird.sight;
                
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
    else {
   
	Bird *animal = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    detailVC=[[DetailTabController alloc] initWithNibName:@"DetailTabController" bundle:nil];

    detailVC.image=animal.image;
    detailVC.name=animal.name;
    detailVC.speciesName=animal.speciesName;
    detailVC.text=animal.text;
    detailVC.shortSound=animal.shortSound;
    detailVC.long_sound=animal.long_sound;
    detailVC.Id=animal.iD;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
    UIView *nilView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    NSString *title=[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, 33)];
    label.text=title;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor brownColor];
    label.font=[UIFont boldSystemFontOfSize:17];
    
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    UIImage *im=[UIImage imageNamed:@"category_plank_new.png"];
    image.image=im;
    [view addSubview:image];
    [view addSubview:label];
    if (searching) {
        return nilView;
    }
    return (showSection) ? view : nilView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    BOOL showSection = [[self.tableData objectAtIndex:section] count] != 0;
    return (showSection) ? 35.0 : 0.0;
}
- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

#pragma mark -
#pragma mark Actions
- (void)searchIconButtonClicked {
    if (self.searchDisplayController.isActive || (self.table.contentOffset.y < 44)) {
        if (self.searchDisplayController.isActive) {
            self.searchDisplayController.searchBar.text = nil;
            [self.searchDisplayController setActive:NO animated:YES];
            [table reloadData];
        }
        [self hideSearchBar];
    } else {
        [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)hideSearchBar {
    //NSLog(@"Hiding SearchBar");        
    [self.table setContentOffset:CGPointMake(0,44)];
}
-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector

{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array)
    {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //sort each section
    for (NSMutableArray *section in unsortedSections)
    {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    
    return sections;
}
#pragma mark -
#pragma mark SearchBar Delegate Methods
                    
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    letUserSelectRow = NO;
    self.table.scrollEnabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)];

}                     
                   
           
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //Remove all objects first.
    [copyListOfItems removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        self.table.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        self.table.scrollEnabled = NO;
    }
    
    [self.table reloadData];
}   // called when text changes (including clear)


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchTableView];
    [sBar resignFirstResponder];
}                     
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self hideSearchBar];
    [sBar resignFirstResponder];
} 

#pragma mark -
#pragma Search Bar Methods
- (void) searchTableView {
    
    NSString *searchText = sBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    [searchArray addObjectsFromArray:arrayNames];
    for (NSString *sTemp in searchArray)
    {
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [copyListOfItems addObject:sTemp];
    }
    
    searchArray = nil;
}
    
- (void) doneSearching_Clicked:(id)sender {
    
    sBar.text = @"";
    [sBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchIconButtonClicked)]; 
    anotherButton.tintColor=[UIColor brownColor];
    self.navigationItem.rightBarButtonItem = anotherButton;
    self.table.scrollEnabled = YES;
    
    [self.table reloadData];
}
@end
