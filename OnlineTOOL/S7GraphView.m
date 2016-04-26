//
//  S7GraphView.m
//  S7Touch
//
//  Created by Aleks Nesterow on 9/27/09.
//  aleks.nesterow@gmail.com
//  
//  Thanks to http://snobit.habrahabr.ru/ for releasing sources for his
//  Cocoa component named GraphView.
//  
//  Copyright © 2009, 7touchGroup, Inc.
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the 7touchGroup, Inc. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY 7touchGroup, Inc. "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL 7touchGroup, Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "S7GraphView.h"
//#import "GraphViewController.h"


@implementation Rect2

@synthesize x, y, w, h;

@end


@interface S7GraphView (PrivateMethods)

- (void)initializeComponent;

@end

@implementation S7GraphView

+ (UIColor *)colorByIndex:(NSInteger)index {
	
	UIColor *color;
	
	switch (index) {
		case 0: color = RGB(5, 141, 191);
			break;
		case 1: color = RGB(80, 180, 50);
			break;		
		case 2: color = RGB(255, 102, 0);
			break;
		case 3: color = RGB(255, 158, 1);
			break;
		case 4: color = RGB(252, 210, 2);
			break;				
		case 5: color = RGB(178, 222, 255);
			break;
		case 8: color = RGB(4, 210, 21);
			break;
		case 7: color = RGB(248, 255, 1);
			break;
		case 6: color = RGB(176, 222, 9);
			break;
		case 9: color = RGB(106, 249, 196);
			break;
		default: color = RGB(204, 204, 204);
			break;
	}
	
	return color;
}

@synthesize xValuesFormatter = _xValuesFormatter, yValuesFormatter = _yValuesFormatter;
@synthesize drawAxisX = _drawAxisX, drawAxisY = _drawAxisY, drawGridX = _drawGridX, drawGridY = _drawGridY;
@synthesize xValuesColor = _xValuesColor, yValuesColor = _yValuesColor, gridXColor = _gridXColor, gridYColor = _gridYColor;
@synthesize drawInfo = _drawInfo, info = _info, infoColor = _infoColor;
@synthesize fillColor = _fillColor, arrRectPoints, arrXValues, arrYValues, arrYLabels;
@synthesize vcParent;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		[self initializeComponent];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	
	if (self = [super initWithCoder:decoder]) {
		[self initializeComponent];
	}
	
	return self;
}

- (void)dealloc {
	
	[_xValuesFormatter release];
	[_yValuesFormatter release];
	
	[_xValuesColor release];
	[_yValuesColor release];
	
	[_gridXColor release];
	[_gridYColor release];
	
	[_info release];
	[_infoColor release];
	
	[arrRectPoints release];
	
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
	CGContextFillRect(c, rect);
	
	NSUInteger numberOfPlots = arrXValues.count < arrYValues.count ? arrXValues.count : arrYValues.count;
	if(!numberOfPlots)
		return;
	
	CGFloat offsetX = _drawAxisY ? 60.0f : 10.0f;
	CGFloat offsetY = (_drawAxisX || _drawInfo) ? 30.0f : 10.0f;
	offsetY += 5;
	offsetX -= 15;
	CGFloat minY = 0.0;
	CGFloat maxY = 0.0;
	
	UIFont *font = [UIFont systemFontOfSize:11.0f];
	
	/*for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
		
		
		for (NSUInteger valueIndex = 0; valueIndex < arrYValues.count; valueIndex++) {
			
			if ([[arrYValues objectAtIndex:valueIndex] floatValue] > maxY) {
				maxY = [[arrYValues objectAtIndex:valueIndex] floatValue];
			}
		}
	}*/
	
	if (maxY < 100) {
		maxY = 5;//ceil(maxY / 10) * 10;
	} 
	
	if (maxY > 100 && maxY < 1000) {
		maxY = ceil(maxY / 100) * 100;
	} 
	
	if (maxY > 1000 && maxY < 10000) {
		maxY = ceil(maxY / 1000) * 1000;
	}
	
	if (maxY > 10000 && maxY < 100000) {
		maxY = ceil(maxY / 10000) * 10000;
	}
	
	CGFloat step = (maxY - minY) / 5;
	CGFloat stepY = (self.frame.size.height - (offsetY * 2)) / maxY;
	
	//NSMutableArray *arrXLabels = [[NSMutableArray alloc] init];
//	for (int i = 0; i<85; i++) {
//		[arrXLabels addObject:[NSString stringWithFormat:@"%d",i]];
//	}
	NSArray *arrXLabels = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",nil];
	stepY =20;
	
	for (NSUInteger i = 1; i < [arrXLabels count]; i++) {
		
		NSUInteger y = (i * step) * stepY;
		NSUInteger value = i * step;
		
		if ( _drawGridY) {
						
			CGContextSetLineWidth(c, 0.4f);
			
			CGPoint startPoint = CGPointMake(offsetX, self.frame.size.height - y - offsetY);
			
			CGPoint endPoint;
			if(i==0)
				endPoint = CGPointMake(self.frame.size.width - offsetX + 35, self.frame.size.height - y - offsetY);
			else
				endPoint = CGPointMake(startPoint.x - [arrXLabels count], startPoint.y);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridYColor.CGColor);
			CGContextStrokePath(c);
			
		}
		
		if (i > 0 && _drawAxisY) {
			
			NSNumber *valueToFormat = [NSNumber numberWithInt:value];
			NSString *valueString = [arrXLabels objectAtIndex:i-1];
			/*
			if (_yValuesFormatter) {
				valueString = [_yValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [valueToFormat stringValue];
			}*/
			
			[self.yValuesColor set];
			CGRect valueStringRect = CGRectMake(0.0f, self.frame.size.height - y - offsetY - [arrXLabels count], 40.0f, 120.0f);
			
			[valueString drawInRect:valueStringRect withFont:font
					  lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
		}
	}
	
	NSUInteger maxStep;
	
	
	NSUInteger xValuesCount = arrXValues.count;
	
	if (xValuesCount > 5) {
		
		NSUInteger stepCount = 5;
		NSUInteger count = xValuesCount - 1;
		
		for (NSUInteger i = 4; i < 8; i++) {
			if (count % i == 0) {
				stepCount = i;
			}
		}
		
		step = xValuesCount / stepCount;
		maxStep = stepCount + 1;
		
	} else {
		
		step = 1;
		maxStep = xValuesCount;
	}
	
	CGFloat stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	for (NSUInteger i = 0; i < maxStep; i++) {
		
		NSUInteger x = (i * step) * stepX;
		
		if (x > self.frame.size.width - (offsetX * 2)) {
			x = self.frame.size.width - (offsetX * 2);
		}
		
		NSUInteger index = i * step;
		
		if (index >= xValuesCount) {
			index = xValuesCount - 1;
		}
		
		if (i==0 && _drawGridX) {
			
			
			CGContextSetLineWidth(c, 0.4f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, offsetY + 35);
			CGPoint endPoint = CGPointMake(x + offsetX, self.frame.size.height - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y - offsetY);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridXColor.CGColor);
			CGContextStrokePath(c);
			
		}
		

		
		if (_drawAxisX) {
			
			id valueToFormat = [arrXValues objectAtIndex:index];
			NSString *valueString;
			
			if (_xValuesFormatter) {
				valueString = [_xValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [NSString stringWithFormat:@"%@", valueToFormat];
			}
			
			[self.xValuesColor set];
			[valueString drawInRect:CGRectMake(x + offsetX, self.frame.size.height - 30.0f, stepX, 180.0f) withFont:font
					  lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
		}
	}
	
	stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	CGContextSetLineDash(c, 0, NULL, 0);
	CGContextSetLineWidth(c, 1.5f);
	CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
	
	
	BOOL shouldFill = YES;
	int x, y , w, h;
	
	for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
		
		
		
		CGColorRef plotColor = [S7GraphView colorByIndex:plotIndex%10].CGColor;							
		CGColorRef plotColor2 = [[UIColor colorWithCGColor:plotColor] colorWithAlphaComponent:.8f].CGColor;
		//plotColor2 = [UIColor colorWithWhite:0.2f alpha:0.8f].CGColor;
		
		// Color Bar
		int v =  [[arrYValues objectAtIndex:plotIndex] intValue];
		int gap = 9;
		x = plotIndex * stepX + offsetX;
		y = self.frame.size.height - (v*stepY) - offsetY;
		w = stepX-gap;
		h = v * stepY;
		
		CGContextAddRect(c,CGRectMake(x, y, w, h));								
		CGContextSetFillColorWithColor(c, plotColor);		
		(shouldFill) ? CGContextFillPath(c) : CGContextClosePath(c);
		
		
		
		
		// 3d effects
		int gap3d = 7;
		CGContextMoveToPoint(c, x, y);
		CGContextAddLineToPoint(c, x+gap3d, y-gap3d);
		CGContextAddLineToPoint(c, x+gap3d, y);
		CGContextClosePath(c);
		
		x += w; y += h;
		CGContextMoveToPoint(c, x, y);
		CGContextAddLineToPoint(c, x+gap3d, y-gap3d);
		CGContextAddLineToPoint(c, x, y-gap3d);
		CGContextClosePath(c);						
		x -= w; y -= h;
		
		CGContextAddRect(c,CGRectMake(x+gap3d, y-gap3d, w, gap3d));
		CGContextAddRect(c,CGRectMake(x+w, y-gap3d, gap3d, h));								 				
				
		CGContextSetFillColorWithColor(c, plotColor2);		
		(shouldFill) ? CGContextFillPath(c) : CGContextClosePath(c);
		
		//store for drill down
		Rect2 *rect = [[Rect2 alloc] init];
		rect.x = x; rect.y = y - gap3d; rect.w = w + gap3d; rect.h = h;
		[arrRectPoints addObject:rect];
		[rect release];
	}
	
	if (_drawInfo) {
		
		font = [UIFont boldSystemFontOfSize:13.0f];
		[self.infoColor set];
		[_info drawInRect:CGRectMake(0.0f, 5.0f, self.frame.size.width, 20.0f) withFont:font
			lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
}


	
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//GraphViewController *chartController = [[GraphViewController alloc] initWithNibName:@"GraphViewController" bundle:nil];	
	//vcParent.title = @"eRIMS2";

	//[vcParent.navigationController pushViewController:chartController animated:YES];

	//[chartController release];
	
}


- (void)reloadData {
	
	[self setNeedsDisplay];
}

#pragma mark PrivateMethods

- (void)initializeComponent {
	
	_drawAxisX = YES;
	_drawAxisY = YES;
	_drawGridX = YES;
	_drawGridY = YES;
	
	_xValuesColor = [[UIColor blackColor] retain];
	_yValuesColor = [[UIColor blackColor] retain];
	
	_gridXColor = [[UIColor blackColor] retain];
	_gridYColor = [[UIColor blackColor] retain];
	
	_drawInfo = NO;
	_infoColor = [[UIColor blackColor] retain];
 	arrRectPoints = [[NSMutableArray alloc] init];

}

@end
