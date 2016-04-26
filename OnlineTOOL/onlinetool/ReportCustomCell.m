//
//  ReportCustomCell.m
//  onlinetool
//
//  Created by apple on 11/18/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import "ReportCustomCell.h"


@implementation ReportCustomCell

@synthesize lbl1,lbl2,lbl3,lbl4,lbl5;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/




- (void)dealloc {
    [super dealloc];
	
	[lbl1 release];
	[lbl2 release];
	[lbl3 release];
	[lbl4 release];
	[lbl5 release];
}


@end
