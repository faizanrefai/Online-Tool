
#import "UIAlertView+utils.h"


@implementation UIAlertView (utils)

+(void)showInfo:(NSString*)msg WithTitle:(NSString*)title Delegate:(id)sender{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:sender cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
