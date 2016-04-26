//
//  UserViewCell.h
//  SportsQuiz
//
//  Created by sparsh on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserViewCell : UITableViewCell
{

	UILabel *lblName;
	UIButton *btnRadio;
	
}
@property(nonatomic, retain) IBOutlet UILabel *lblName;
@property(nonatomic, retain) IBOutlet UIButton *btnRadio;


@end
