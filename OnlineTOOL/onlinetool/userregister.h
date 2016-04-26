//
//  userregister.h
//  glueme
//
//  Created by apple on 9/19/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface userregister : UIViewController {

	
	IBOutlet UIScrollView *scroll;
	
	IBOutlet UITextField *fnametext;
	IBOutlet UITextField *lnametext;
	IBOutlet UITextField *emailtext;
	IBOutlet UITextField *passwordtext;
	IBOutlet UITextField *confirmpasstext;
	IBOutlet UITextField *phntext;
	
	IBOutlet UIButton *registerbtn;
	IBOutlet UIButton *cancelbtn;
	
	CGFloat animatedDistance;
}


-(IBAction)cancelbtn_clicked;
-(IBAction)registerbtn_clicked;


@end
