//
//  LoginViewController.m
//  Leopard
//
//  Created by OPENXCELL TECHNOLABS on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"



@implementation LoginViewController
@synthesize isLoginArr , webService , u_name , u_pwd;


-(void)viewDidLoad
{
	[super viewDidLoad];
    
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:77.0/255.0 green:32.0/255.0 blue:122.0/255.0 alpha:1.0]];
	//logintext.text = @"aarp";
//	passwordtext.text = @"aarp2009";
//	
	//logintext.text = @"pmcsp/cuddledown";
//	passwordtext.text = @"cuddledown11";
//	
//	logintext.text = @"MCalveric";
//	passwordtext.text = @"Mar2011";
	
	logintext.layer.borderColor = [UIColor orangeColor].CGColor;
	logintext.layer.borderWidth = 2;
	logintext.layer.cornerRadius = 15.0;
	
	passwordtext.layer.borderColor = [UIColor orangeColor].CGColor;
	passwordtext.layer.borderWidth = 2;
	passwordtext.layer.cornerRadius = 15.0;
	
	appDelegate = (onlinetoolAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	bigLabel.text = @"Welcome";
	bigLabel.backgroundColor = [UIColor clearColor];
	bigLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	bigLabel.numberOfLines = 1;
	bigLabel.textColor = [UIColor orangeColor];
	[bigLabel setTextAlignment:UITextAlignmentCenter];
	self.navigationItem.titleView = bigLabel;
	[bigLabel release];
	
}

-(void)viewWillAppear:(BOOL)animated
{
		self.navigationController.navigationBar.hidden = FALSE;
}

//-(IBAction)signup_btnclicked:(id)sender
//{
//    userregister *obj_signup = [[userregister alloc]initWithNibName:@"userregister" bundle:nil];
//    [self presentModalViewController:obj_signup animated:YES];
//    
//    
//}
-(IBAction)login_btnclicked:(id)sender
{
   
	
	[logintext resignFirstResponder];
	[passwordtext resignFirstResponder];
	
	self.u_name = [logintext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	self.u_pwd = [passwordtext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	
	if ([self.u_name isEqualToString:@""] || [self.u_pwd isEqualToString:@""]) {
		[customealert showAlert:@"Alert" message:@"Username/Password can not be null." delegate:self];
	}
	else {
		[self prepareToCallgetClientWS];
	}
}


#pragma mark  Web service - prepareToCallWS


-(void)prepareToCallgetClientWS {
	
	[self showHUD];
	[self performSelector:@selector(callgetClientWS) withObject:nil afterDelay:0.01];
	
}

-(void)callgetClientWS{
	
	WebService *webservice = (WebService *)[[WebService alloc] initWithDelegate:self];
	self.webService = webservice;
	[webservice release];
	
	//NSString *a1 = @"aarp";
	//	NSString *a2 = @"aarp2009";
	
	NSMutableDictionary *webEventDict = [appDelegate.webDict objectForKey:@"CgetClients"];
	//NSString *request = [[webEventDict objectForKey:@"envelope"],a1,a2]; 
	NSString *request = [NSString stringWithFormat:[webEventDict objectForKey:@"envelope"], self.u_name,self.u_pwd];
	
	NSString *soapAction = [webEventDict objectForKey:@"soapAction"];
	[webService callWebSetvice:request withSoapAction:soapAction];
}



#pragma mark -
#pragma mark Common Connection Finish


-(void)connectionFinish:(NSString*)strResponse{
	
	NSError *error = nil;
	CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:strResponse
														 options:0 error:&error]autorelease];
	if(!doc){
		[self hideHUD];
		//[MessageAlertView showAlert:AlertName message:@"Unknown error." delegate:self];
		return;
	}
	
	else {
		NSArray *nodes = [webService nodesForXPath:@"//Clients" MainNode:doc nameSpace:nil Error:&error];	
		NSMutableArray * eventBufferArray = [[NSMutableArray alloc] init];
		
		for(CXMLNode *node in nodes){
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			
			for (int i=0; i<[node childCount]; i++) {
				[dict setValue:[[node childAtIndex:i]stringValue] forKey:[[node childAtIndex:i]name]];
			}
			[eventBufferArray addObject:dict];
			[dict release];
		}
		
		
		
		NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
		[eventBufferArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
		[sortDescriptor1 release];
		self.isLoginArr = eventBufferArray;
		//[tblUserName reloadData];
		[eventBufferArray release];
		
		
		[self hideHUD];
		
		if ([self.isLoginArr count]!=0) 
		{
			clientviewcontroller *obj_login = [[clientviewcontroller alloc]initWithNibName:@"clientviewcontroller" bundle:nil];
			
			[obj_login setValueUname:self.isLoginArr Username:self.u_name Password:self.u_pwd];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:1.0];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
			[self.navigationController pushViewController:obj_login animated:YES];
			[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
			[UIView commitAnimations];
		}
		else {
			[customealert showAlert:@"Alert" message:@"Invalid Username/Password." delegate:self];
		}

	}
}


-(void)connectionError:(NSError*)err{
	[self hideHUD];
}

-(void)showHUD{
	[self hideHUD];
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = @"Processing..";
	[HUD show:YES];
	self.view.userInteractionEnabled = NO;
}
-(void)hideHUD{
	if (HUD) {
		[HUD hide:YES];
		[HUD removeFromSuperview];
		[HUD release];
		HUD = nil;
		self.view.userInteractionEnabled = YES;
	}
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [logintext resignFirstResponder];
    [passwordtext resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[u_name release];
	[u_pwd release];
	[webService release];
	[isLoginArr release];
}


@end
