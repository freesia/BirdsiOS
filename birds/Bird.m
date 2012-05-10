//
//  Bird.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bird.h"

@implementation Bird
@synthesize name, speciesName,iD,image,text,shortSound,long_sound;



-(id)initWithName:(NSString *)n speciesName:(NSString *)d image:(NSString *)im text:(NSString*)txt shortSound:(NSString*)sound1 longSound:(NSString*)sound2 id:(int)i{
	self.name = n;
	self.speciesName = d;
	self.image = im;
    self.text = txt;
    self.shortSound=sound1;
    self.long_sound=sound2;
    self.iD=i;
	return self;
}
@end
