//
//  SwitcherCellVC.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitcherCellVC : UITableViewCell {
     UILabel *textLabel;
     UISwitch *switcher;

}
@property (nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic) IBOutlet UISwitch *switcher;
@end
