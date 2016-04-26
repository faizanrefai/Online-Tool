//
//  clientviewcontroller.h
//  onlinetool
//
//  Created by apple on 9/24/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportViewController.h"
#import "onlinetoolAppDelegate.h"
#import "AlertHandler.h"
#import "WebService.h"





@interface clientviewcontroller : UIViewController <UITableViewDelegate , UITableViewDataSource> {
    
	MBProgressHUD *HUD;
	
    IBOutlet UITableView *mytabel;

	WebService *webService;
	
	IBOutlet UINavigationBar *navi;
	
	onlinetoolAppDelegate *appDelegate;
	
    NSMutableArray *clientarr;
	
	NSString *u_name;
	
	NSString *u_pwd;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSMutableArray *clientarr;
@property (nonatomic, retain) NSString *u_name;
@property (nonatomic, retain) NSString *u_pwd;

- (NSString *)decodeHTMLEntities:(NSString *)string;
-(IBAction)Logout;
-(void)setValueUname:(NSMutableArray*)arr Username:(NSString*)unm Password:(NSString*)pwd;


@end
