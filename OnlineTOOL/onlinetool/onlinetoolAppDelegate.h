//
//  onlinetoolAppDelegate.h
//  onlinetool
//
//  Created by apple on 9/24/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface onlinetoolAppDelegate : NSObject <UIApplicationDelegate> {

	
	NSMutableDictionary *webDict;
	
	
	
}

@property (nonatomic, retain) NSMutableDictionary *webDict;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
