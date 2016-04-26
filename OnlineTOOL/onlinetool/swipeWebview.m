//
//  swipeWebview.m
//  flashCard
//
//  Created by apple on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "swipeWebview.h"


@implementation swipeWebview


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	[self.nextResponder touchesBegan:touches withEvent:event];
	
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	[self.nextResponder touchesMoved:touches withEvent:event];
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	[self.nextResponder touchesEnded:touches withEvent:event];
	
}




@end
