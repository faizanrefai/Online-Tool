//
//  UserViewCell.m
//  SportsQuiz
//
//  Created by sparsh on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserViewCell.h"


@implementation UserViewCell
@synthesize lblName;
@synthesize btnRadio;

- (void)dealloc {
	[btnRadio release];
	[lblName release];
    [super dealloc];
}


@end

