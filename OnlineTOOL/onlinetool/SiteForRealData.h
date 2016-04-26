//
//  SiteForRealData.h
//  onlinetool
//
//  Created by apple on 2/14/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "UserViewCell.h"
#import "UITableViewCell+NIB.h"

@protocol UserDelegate <NSObject>
@optional

-(void)change_site_name:(NSString*)name;

@end

@interface SiteForRealData : OverlayView <UITableViewDelegate , UITableViewDataSource>{

	id<UserDelegate>_userDelegate;
	
	NSMutableArray *site_array;
	
	IBOutlet UITableView *my_tbl;
	
	NSString *sitename;
	
	NSMutableArray *arrayselectedRows;
	NSMutableArray *arrayCheckBox;
	
}

@property(nonatomic, assign)id<UserDelegate>_userDelegate;
@property(nonatomic , retain)NSMutableArray *site_array;
@property(nonatomic , retain)IBOutlet UITableView *my_tbl;
@property(nonatomic , retain)NSString *sitename;
@property(nonatomic , retain)NSMutableArray * arrayCheckBox;
@property(nonatomic , retain)NSMutableArray * arrayselectedRows;

+(void)showAlert:(NSMutableArray*)myArr siteName:(NSString*)name delegate:(id)sender;

@end
