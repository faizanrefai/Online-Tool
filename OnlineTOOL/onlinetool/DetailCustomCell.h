//
//  DetailCustomCell.h
//  onlinetool
//
//  Created by apple on 11/18/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailCustomCell : UITableViewCell {

	
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
	IBOutlet UILabel *label3;
	
}

@property (nonatomic , retain)IBOutlet UILabel *label1;
@property (nonatomic , retain)IBOutlet UILabel *label2;
@property (nonatomic , retain)IBOutlet UILabel *label3;


@end
