//
//  CustomDetailLbl.m
//  onlinetool
//
//  Created by apple on 2/18/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import "CustomDetailLbl.h"


@implementation CustomDetailLbl

@synthesize Date_lbl,value_lbl;



- (void)dealloc {
    [super dealloc];
	[Date_lbl release];
	[value_lbl release];
}


@end
