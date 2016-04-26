//
//  SiteForRealData.m
//  onlinetool
//
//  Created by apple on 2/14/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import "SiteForRealData.h"


@implementation SiteForRealData

@synthesize _userDelegate,site_array,my_tbl,sitename,arrayCheckBox,arrayselectedRows;



+(void)showAlert:(NSMutableArray*)myArr siteName:(NSString*)name delegate:(id)sender{
	
	UIViewController *controller = [[UIViewController alloc] initWithNibName:@"SiteForRealData" bundle:[NSBundle mainBundle]];
	SiteForRealData *customeAlertView = (SiteForRealData *)controller.view;
	customeAlertView.site_array = myArr;
	customeAlertView._userDelegate = sender;
	customeAlertView.sitename = name;
	[customeAlertView show];
	[controller release];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([site_array count]<7) {
		my_tbl.scrollEnabled = FALSE;
	}
	
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.site_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UserViewCell *cell = [UserViewCell dequeOrCreateInTable:tableView];
	cell.lblName.text = [site_array objectAtIndex:indexPath.row];
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	cell.btnRadio.tag = indexPath.row;
	
	
	[arrayCheckBox replaceObjectAtIndex:indexPath.row withObject:cell.btnRadio];
	
	if ([[arrayselectedRows objectAtIndex:cell.btnRadio.tag]isEqual:@"1"]) {
		cell.btnRadio.selected=YES;
	}
	else if ([[arrayselectedRows objectAtIndex:cell.btnRadio.tag]isEqual:@"0"]){
		cell.btnRadio.selected=NO;
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([_userDelegate respondsToSelector:@selector(change_site_name:)])
		[_userDelegate change_site_name:[site_array objectAtIndex:indexPath.row]];
	[self dismiss:YES];
}


#pragma mark -
#pragma mark Baseclass methods

- (void)dialogWillAppear {
	
	//arrayselectedRows = [[NSMutableArray alloc]init];
	
	
	NSMutableArray *temparrayselectedRows =[[NSMutableArray alloc]init];
	for(int i=0;i<[site_array count];i++) {
		
		if([sitename isEqualToString:[NSString stringWithFormat:@"%@",[site_array objectAtIndex:i]]])
		{
			[temparrayselectedRows addObject:@"1"];
		}else
		{
			[temparrayselectedRows addObject:@"0"];
		}
	}
	self.arrayselectedRows = temparrayselectedRows;
	[temparrayselectedRows release];
	
	
	NSMutableArray *temparrayCheckBox =[[NSMutableArray alloc]init];
	for (int i=0; i<[site_array count]; i++) {
		if([sitename isEqualToString:[NSString stringWithFormat:@"%@",[site_array objectAtIndex:i]]])
		{
			[temparrayCheckBox addObject:@"1"];
		}else
		{
			[temparrayCheckBox addObject:@"0"];
		}
	}
	self.arrayCheckBox = temparrayCheckBox;
	[temparrayCheckBox release];
	
	
	
	[super dialogWillAppear];
}


- (void)dialogWillDisappear {
	[super dialogWillDisappear];
}


- (void)dealloc {
    [super dealloc];
}


@end
