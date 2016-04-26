//
//  clientviewcontroller.m
//  onlinetool
//
//  Created by apple on 9/24/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import "clientviewcontroller.h"


@implementation clientviewcontroller


@synthesize clientarr,webService,u_name,u_pwd;



//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    [super dealloc];
//}
//

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.title = @"Clients";
	self.navigationController.navigationBar.hidden = TRUE;
	
	self.navigationController.navigationItem.backBarButtonItem.title = @"";
	self.navigationItem.backBarButtonItem.title = @"";
	
	appDelegate = (onlinetoolAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	bigLabel.text = @"Clients";
	bigLabel.backgroundColor = [UIColor clearColor];
	bigLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	bigLabel.numberOfLines = 1;
	bigLabel.textColor = [UIColor orangeColor];
	[bigLabel setTextAlignment:UITextAlignmentCenter];
	//self.navigationItem.titleView = bigLabel;
	[navi addSubview:bigLabel];
	[bigLabel release];
	
	
    
}

-(void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.hidden = TRUE;
	
	[mytabel reloadData];
}

-(IBAction)Logout
{
	[self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

#pragma mark  set UserName & Password

-(void)setValueUname:(NSMutableArray*)arr Username:(NSString*)unm Password:(NSString*)pwd
{	
	
	self.u_name = unm;
	self.u_pwd = pwd;
	self.clientarr = [arr copy];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
       return [self.clientarr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
	}
		// Configure the cell.
	

    
    // Set up the animation
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.textLabel.text = [[self.clientarr valueForKey:@"Client"]objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:17];
	cell.textLabel.numberOfLines = 2;
	[cell.textLabel setLineBreakMode:UILineBreakModeClip];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReportViewController *obj_report = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
	[obj_report setValueUname:self.u_name Pwd:self.u_pwd Client:[self decodeHTMLEntities:[NSString stringWithFormat:@"%@",[[self.clientarr valueForKey:@"Client"]objectAtIndex:indexPath.row]]]];
	[self.navigationController pushViewController:obj_report animated:YES];
	[obj_report release];
	    
}


- (NSString *)decodeHTMLEntities:(NSString *)string {
	// Reserved Characters in HTML
	string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	
	return string;
}


#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dealloc

-(void)dealloc
{
	[super dealloc];
	[self.clientarr release];
	[self.u_name release];
	[self.u_pwd release];
	
	[webService release];
	
	appDelegate = nil;
	navi = nil;
	
}
@end
