//
//  LoginViewController.h
//  Leopard
//
//  Created by OPENXCELL TECHNOLABS on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clientviewcontroller.h"
#import "onlinetoolAppDelegate.h"
#import "userregister.h"

#import "AlertHandler.h"
#import "WebService.h"
#import "customealert.h"

@interface LoginViewController : UIViewController {
	
	WebService *webService;
	MBProgressHUD *HUD;
	onlinetoolAppDelegate *appDelegate;
	
    IBOutlet UITextField *logintext;
    IBOutlet UITextField *passwordtext;
	
	NSMutableArray *isLoginArr;
	
	NSString *u_name;
	
	NSString *u_pwd;
	
}
@property (nonatomic, retain) NSString *u_name;
@property (nonatomic, retain) NSString *u_pwd;

@property (nonatomic, retain) WebService *webService;
@property( nonatomic , retain ) NSMutableArray *isLoginArr;


-(IBAction)login_btnclicked:(id)sender;

-(void)prepareToCallgetClientWS;
-(void)callgetClientWS;
-(void)showHUD;
-(void)hideHUD;

@end
