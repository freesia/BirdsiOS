//
//  Bird.h
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bird : NSObject {
    NSString *name;
    NSString *speciesName;
    NSString *id;
    NSString *shortSound;
    NSString *long_sound;
    NSString *image;
    NSString *text;
        
}
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *speciesName;
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *shortSound;
@property (nonatomic) NSString *long_sound;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *text;

-(id)initWithName:(NSString *)n speciesName:(NSString *)d image:(NSString *)im text:(NSString*)txt shortSound:(NSString*)sound1 longSound:(NSString*)sound;
@end
