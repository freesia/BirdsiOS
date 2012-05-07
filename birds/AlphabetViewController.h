//
//  AlphabetViewController.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailTabController.h"



@interface AlphabetViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate> {

    IBOutlet UITableView *table;
    UISearchBar *sBar;

    DetailTabController *detailVC;
    
    NSMutableArray *myArray;
    NSArray *titles;
    NSMutableArray *copyListOfItems;
    
    NSMutableArray *arrayNames;
        
    NSMutableArray *tableData;
        
    NSMutableArray *dataSource; //will be storing all the data
    NSMutableArray *tableDataSearch;//will be storing data that will be displayed in table
    NSMutableArray *searchedData;//will be storing data matching with the search string
    
    BOOL searching;
    BOOL letUserSelectRow;
}
@property (nonatomic) UITableView *table;
@property (nonatomic) NSArray *titles;
@property (nonatomic) NSMutableArray *dataSource;
@property (readwrite, copy, nonatomic) NSArray *tableData;
@property (nonatomic) UISearchBar *sBar;


- (void)hideSearchBar;
- (void)searchIconButtonClicked;
-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector;

@end
