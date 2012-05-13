//
//  BirdCell.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdCell : UITableViewCell {
    UILabel *birdtitle;
    UILabel *birdDiscr;
    UIImageView *birdImage;
    UILabel *sightLabel;

}
@property (nonatomic) IBOutlet UILabel *sightLabel;
@property (nonatomic) IBOutlet  UILabel *birdtitle;
@property (nonatomic) IBOutlet UILabel *birdDiscr;
@property (nonatomic) IBOutlet UIImageView *birdImage;
@end
