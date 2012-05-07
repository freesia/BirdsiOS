//
//  DesciptionVC.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTabController.h"

@interface DesciptionVC : UIViewController {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *speciesLabel;
    IBOutlet UIImageView *image;
    IBOutlet UITextView *text;
    
    IBOutlet UIView *bigImageView;
    IBOutlet UIImageView *bigImage;
    
    DetailTabController *detailVC;
}
@property (nonatomic)DetailTabController *detailVC;


- (IBAction)zoomButtonPressed;
- (IBAction)zoomOutButtonPressed;
@end
