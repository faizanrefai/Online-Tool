//
//  CustomDetailLbl.h
//  onlinetool
//
//  Created by apple on 2/18/12.
//  Copyright 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomDetailLbl : UITableViewCell {

	IBOutlet UILabel *Date_lbl;
	IBOutlet UILabel *value_lbl;
	
}

@property ( nonatomic , retain )IBOutlet UILabel *Date_lbl;
@property ( nonatomic , retain )IBOutlet UILabel *value_lbl;

@end
