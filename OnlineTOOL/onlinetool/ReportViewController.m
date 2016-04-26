//
//  ReportViewController.m
//  onlinetool
//
//  Created by apple on 9/24/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import "ReportViewController.h"




@implementation ReportViewController

@synthesize u_name,u_pwd,webService,clientname,Site_Name,Date_Count,Cat_Name,myDetailDataArray,refreshStr;
@synthesize RealCatName,myDetailDataArray_graph,RealTime_SortArr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	bigLabel.text = @"Reports";
	bigLabel.backgroundColor = [UIColor clearColor];
	bigLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	bigLabel.numberOfLines = 1;
	bigLabel.textColor = [UIColor orangeColor];
	[bigLabel setTextAlignment:UITextAlignmentCenter];
	self.navigationItem.titleView = bigLabel;
	[bigLabel release];
	
    formatter0000 = [[NSDateFormatter alloc] init];
    //self.title = @"Reports";
    dateView.hidden = TRUE;
	
	site_name_lbl.layer.borderColor = [UIColor blackColor].CGColor;
	site_name_lbl.layer.borderWidth = 1;
	
	date_name_lbl.layer.borderColor = [UIColor blackColor].CGColor;
	date_name_lbl.layer.borderWidth = 1;
	
	
    realtimeview.hidden = FALSE;
    detailview.hidden = TRUE;
    summaryview.hidden = TRUE;
	
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	
	
	refreshArray = [[NSMutableArray alloc]initWithObjects:@"Refresh Now",@"Every 5 Minute",@"Every 10 Minute",@"Every 15 Minute",@"Auto Refresh Off",nil];
	

	myMartixDetailArr = [[NSMutableArray alloc]initWithObjects:@"Clicks",@"Gross Spend",@"Orders",@"Revenue",@"A to S",nil];
	
	myMartixRealArr = [[NSMutableArray alloc]initWithObjects:@"Clicks",@"Orders",@"Revenue",nil];
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"ALL SITE" style:UIBarButtonItemStyleBordered target:self action:@selector(selectSite:)];
	homeButton.tag = 1;
	[self.navigationItem setRightBarButtonItem:homeButton];
	[homeButton release];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back_btn_clicked)];
	[self.navigationItem setLeftBarButtonItem:backButton];
	[backButton release]; 
	
	appDelegate = (onlinetoolAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	self.navigationController.navigationBar.hidden = FALSE;
	
	self.refreshStr = @"Auto Refresh Off";
	
	
	graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	//CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	CPTTheme *theme = [[TestXYTheme alloc] init] ;
	[graph applyTheme:theme];
	[theme release];
	
	hostingGraphView = (CPTGraphHostingView *)hostingGraphView;
	[hostingGraphView setHidden:FALSE];
	hostingGraphView.hostedGraph = graph;
	hostingGraphView.backgroundColor = [UIColor clearColor];
	
	graph.paddingLeft   = 5.0;
	graph.paddingTop    = 0.0;
	graph.paddingRight  = 5.0;
	graph.paddingBottom = 0.0;
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
	
	CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
	NSString *identy = [NSString stringWithFormat:@"DataPlot"];
	dataSourceLinePlot.identifier =identy;
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:dataSourceLinePlot, nil]];
	
	CPTMutableLineStyle *lineStyle1 = [dataSourceLinePlot.dataLineStyle mutableCopy] ;
	lineStyle1.lineWidth = 1.f;
	lineStyle1.lineColor = [CPTColor greenColor];
	dataSourceLinePlot.dataLineStyle = lineStyle1;
	dataSourceLinePlot.dataSource = self;

    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol rectanglePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(7.0, 7.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
    dataSourceLinePlot.delegate = self; 
	dataSourceLinePlot.dataSource = self; 
	
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
	[graph addPlot:dataSourceLinePlot];
	
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 11;
    textStyle.color = [CPTColor whiteColor];
	
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	axisSet.xAxis.labelTextStyle = textStyle;
	axisSet.yAxis.labelTextStyle = textStyle;
	
	CPTXYAxis *x = axisSet.xAxis;
	x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	[x setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
	
	
	CPTXYAxis *y = axisSet.yAxis;
	y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	[y setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
	
	
	
	
	[self real_graph_view];
}


-(void)real_graph_view
{
	Real_graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	//CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	CPTTheme *theme = [[TestXYTheme alloc] init] ;
	[Real_graph applyTheme:theme];
	[theme release];
	
	Real_hostingGraphView = (CPTGraphHostingView *)Real_hostingGraphView;
	[Real_hostingGraphView setHidden:FALSE];
	Real_hostingGraphView.hostedGraph = Real_graph;
	Real_hostingGraphView.backgroundColor = [UIColor clearColor];
	
	Real_graph.paddingLeft   = 10.0;
	Real_graph.paddingTop    = 40.0;
	Real_graph.paddingRight  = 10.0;
	Real_graph.paddingBottom = 10.0;
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)Real_graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
	
	CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
	dataSourceLinePlot.delegate = self;
	dataSourceLinePlot.dataSource = self;
	NSString *identy = [NSString stringWithFormat:@"DataPlot"];
	dataSourceLinePlot.identifier =identy;
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:dataSourceLinePlot, nil]];
	
	CPTMutableLineStyle *lineStyle1 = [dataSourceLinePlot.dataLineStyle mutableCopy] ;
	lineStyle1.lineWidth = 1.f;
	lineStyle1.lineColor = [CPTColor greenColor];
	dataSourceLinePlot.dataLineStyle = lineStyle1;
	dataSourceLinePlot.dataSource = self;
	
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol rectanglePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(7.0, 7.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
     
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;
	[Real_graph addPlot:dataSourceLinePlot];
	
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 11;
    textStyle.color = [CPTColor whiteColor];
	
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)Real_graph.axisSet;
	axisSet.xAxis.labelTextStyle = textStyle;
	axisSet.yAxis.labelTextStyle = textStyle;
	
	CPTXYAxis *x = axisSet.xAxis;
	[x setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
	
	CPTXYAxis *y = axisSet.yAxis;
	[y setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
	
}


-(void)viewWillAppear:(BOOL)animated
{
	D_S_Arr = [[NSMutableArray alloc]init];
	realtimeArr = [[NSMutableArray alloc]init];
	
	realtime_site_arr = [[NSMutableArray alloc]init];
	D_S_site_arr = [[NSMutableArray alloc]init];
	
	
	self.Site_Name = @"ALL SITE";
	self.Date_Count = @"61";
	self.Cat_Name = @"Clicks";
	self.RealCatName = @"Clicks";
	
	self.navigationItem.rightBarButtonItem.title = @"ALL SITE";
	[matrics_btndetail setTitle:@"Clicks" forState:UIControlStateNormal];
	
	day_btn1.selected = FALSE;
	day_btn2.selected = FALSE;
	day_btn3.selected = YES;
	
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	self.navigationItem.leftBarButtonItem.enabled = FALSE;
	[self CgetRealTimePerformanceDataWS];
}

#pragma mark  set UserName & Password

-(void)setValueUname:(NSString*)uname Pwd:(NSString*)pwd Client:(NSString*)client
{
	self.u_name = uname;
	self.u_pwd = pwd;
	self.clientname = client;
}

-(IBAction)refresh_btn_clicked:(id)sender
{
	SiteAndCatFlag = 3;
	[SiteForRealData showAlert:refreshArray siteName:refreshStr delegate:self];
	//[self viewWillAppear:NO];
}

#pragma mark  Web service - prepareToCallWS


-(void)CgetRealTimePerformanceDataWS {
	[self showHUD];
	[self performSelector:@selector(CgetRealTimePerformanceData) withObject:nil afterDelay:0.01];
}



-(void)CgetRealTimePerformanceData{
	
	WebService *webservice = (WebService *)[[WebService alloc] initWithDelegate:self];
	self.webService = webservice;
	[webservice release];
	
	NSMutableDictionary *webEventDict = [appDelegate.webDict objectForKey:@"CgetRealTimePerformanceData"];
	//NSString *request = [[webEventDict objectForKey:@"envelope"],a1,a2]; 
	NSString *request = [NSString stringWithFormat:[webEventDict objectForKey:@"envelope"],self.clientname];
	
	NSString *soapAction = [webEventDict objectForKey:@"soapAction"];
	[webService callWebSetvice:request withSoapAction:soapAction];
}



-(void)CgetDailyPerformanceDataWS {
	[self performSelector:@selector(CgetDailyPerformanceData) withObject:nil afterDelay:0.01];
}


-(void)CgetDailyPerformanceData{
	
	WebService *webservice = (WebService *)[[WebService alloc] initWithDelegate:self];
	self.webService = webservice;
	[webservice release];
	
	NSMutableDictionary *webEventDict = [appDelegate.webDict objectForKey:@"CgetDailyPerformanceData"];
	NSString *request = [NSString stringWithFormat:[webEventDict objectForKey:@"envelope"],self.clientname,self.u_name,self.u_pwd];
	
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
		return;
	}
	
	else if (CgetSitesflag == TRUE)
	{
		CgetSitesflag = FALSE;
		NSArray *nodes = [webService nodesForXPath:[NSString stringWithFormat:@"//%@",[self decodeHTMLEntities:self.clientname]] MainNode:doc nameSpace:nil Error:&error];	
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
		
		
		
		NSMutableArray *temp_arr = [[NSMutableArray alloc]init];
		for (int i = 1; i<[eventBufferArray count]; i++) {
				[temp_arr addObject:[eventBufferArray objectAtIndex:i]];
		}
		
		D_S_Arr = [temp_arr copy];
		
		for (int i = 0; i<[D_S_Arr count]; i++) {
			
			if ([[D_S_Arr objectAtIndex:i] objectForKey:@"Site"]) {
				NSString *str = [[D_S_Arr objectAtIndex:i] valueForKey:@"Site"];
				if (![realtime_site_arr containsObject:str]) {
					[realtime_site_arr addObject:str];
				}
			}
		}
		
		temp_arr = nil;
		[temp_arr release];
		eventBufferArray = nil;
		[eventBufferArray release];
		
		[self performSelector:@selector(filter_summary_data) withObject:nil afterDelay:0.01];
		[self performSelector:@selector(filter_Detail_data) withObject:nil afterDelay:0.01];
		[self performSelector:@selector(filter_realTime_data) withObject:nil afterDelay:0.01];
		
		self.navigationItem.rightBarButtonItem.enabled = TRUE;
		self.navigationItem.leftBarButtonItem.enabled = TRUE;
		
		[self hideHUD];
	}
	
	else
	{
		CgetSitesflag = TRUE;
		
		NSArray *nodes = [webService nodesForXPath:[NSString stringWithFormat:@"//%@",[self decodeHTMLEntities:self.clientname]] MainNode:doc nameSpace:nil Error:&error];	
		NSMutableArray * eventBufferArray = [[NSMutableArray alloc] init];
		
		for(CXMLNode *node in nodes){
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			
			for (int i=0; i<[node childCount]; i++) {
				[dict setValue:[[node childAtIndex:i]stringValue] forKey:[[node childAtIndex:i]name]];
			}
			
				if ([dict objectForKey:@"Site"]) {
					[eventBufferArray addObject:dict];
					[dict release];
				}
		}
		/////////////////////**************************Realtime************************///////////////
		realtimeArr = [eventBufferArray copy];
		NSLog(@"%@",realtimeArr);
		
		[realtime_site_arr removeAllObjects];
		
		[realtime_site_arr addObject:@"ALL SITE"];
		for (int i = 1; i<[realtimeArr count]; i++) {
			NSString *str = [[realtimeArr objectAtIndex:i] valueForKey:@"Site"];
			if (![realtime_site_arr containsObject:str]) {
				[realtime_site_arr addObject:str];
			}
		}

		eventBufferArray = nil;
		[eventBufferArray release];

		[self performSelector:@selector(CgetDailyPerformanceDataWS) withObject:nil afterDelay:0.01];
	}
}


#pragma mark Delegate Response

-(void)change_site_name:(NSString*)name
{
	if(SiteAndCatFlag == 1)
	{
		self.Site_Name = name;
		self.navigationItem.rightBarButtonItem.title = self.Site_Name;
		site_name_lbl.text = name;

		[self performSelector:@selector(filter_summary_data) withObject:nil afterDelay:0.01];
		[self performSelector:@selector(filter_Detail_data) withObject:nil afterDelay:0.01];
	}
	
	if(SiteAndCatFlag == 2)
	{
		self.Cat_Name = name;
		[matrics_btndetail setTitle:name forState:UIControlStateNormal];
		[self performSelector:@selector(filter_Detail_data) withObject:nil afterDelay:0.01];
	}
	
	if (SiteAndCatFlag == 3) 
	{
		[self performSelector:@selector(select_refresh:) withObject:name afterDelay:0.01];
	}
	
	if (SiteAndCatFlag == 4) 
	{
		self.RealCatName = name;
		[matrics_btn setTitle:name forState:UIControlStateNormal];
		[self performSelector:@selector(filter_realTime_data) withObject:nil afterDelay:0.01];
	}
	
	if (SiteAndCatFlag == 5) 
	{
		self.Site_Name = name;
		self.navigationItem.rightBarButtonItem.title = name;
		[self performSelector:@selector(filter_realTime_data) withObject:nil afterDelay:0.01];
	}
	
}


-(void)select_refresh:(NSString*)str
{
	self.refreshStr = str;
	
	if ([self.refreshStr isEqualToString:@"Refresh Now"]) {
		[timer invalidate];
		[self viewWillAppear:NO];
	}
	
	if ([self.refreshStr isEqualToString:@"Every 5 Minute"]) {
		timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(viewWillAppear:) userInfo:nil repeats:YES];
	}
	
	if ([self.refreshStr isEqualToString:@"Every 10 Minute"]) {
		timer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(viewWillAppear:) userInfo:nil repeats:YES];
	}
	
	if ([self.refreshStr isEqualToString:@"Every 15 Minute"]) {
		timer = [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(viewWillAppear:) userInfo:nil repeats:YES];
	}
	
	if ([self.refreshStr isEqualToString:@"Auto Refresh Off"]) {
		[timer invalidate];
	}
}


-(void)filter_realTime_data
{
	NSMutableArray *RealTime_SortArr_temp = [[NSMutableArray alloc]init];
	for (int i = 0; i < 24; i++) 
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
		int Clicks = 0;
		NSString *temp_str_1 = [self dateWithHourBeforeNow:i];
		
		for (int j = 0; j < [realtimeArr count]; j++) 
		{
			NSString *d_str = [[realtimeArr objectAtIndex:j] valueForKey:@"DateTime"];
			NSString *s_str = [[realtimeArr objectAtIndex:j] valueForKey:@"Site"];
			
			if ([self.Site_Name isEqualToString:@"ALL SITE"]) 
			{
				if ([temp_str_1 isEqualToString:d_str]) 
				{
					float t_Clicks = [[NSString stringWithFormat:@"%@",[[realtimeArr objectAtIndex:j]valueForKey:[NSString stringWithFormat:@"%@",self.RealCatName]]] intValue];
					Clicks = Clicks + t_Clicks;
				}
			}
			else {
				if ([temp_str_1 isEqualToString:d_str] && [s_str isEqualToString:self.Site_Name]) 
				{
					int t_Clicks = [[NSString stringWithFormat:@"%@",[[realtimeArr objectAtIndex:j]valueForKey:[NSString stringWithFormat:@"%@",self.RealCatName]]] intValue];
					Clicks = Clicks + t_Clicks;
				}
			}
		}
		
		
		for (int i = 0; i < [realtimeArr count]; i++) {
			if ([temp_str_1 isEqualToString:[[realtimeArr objectAtIndex:i] valueForKey:@"DateTime"]]) {
				[dict setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
				[dict setObject:[NSString stringWithFormat:@"%d",Clicks] forKey:@"val"];
				
				[RealTime_SortArr_temp addObject:dict];
				
				dict = nil;
				[dict release];
				
				break;
			}
		}
	}
	self.RealTime_SortArr = RealTime_SortArr_temp;
	
	RealTime_SortArr_temp = nil;
	[RealTime_SortArr_temp release];
	
	[self performSelector:@selector(Core_plot_For_RealTime) withObject:nil afterDelay:0.01];
}



#pragma mark filter_summary_data

-(void)filter_summary_data
{
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSDate *now = [NSDate date];
	NSString *str=[[NSString	alloc]init];
	str=[dateFormatter stringFromDate:now];
	
	int Clicks = 0;
	int Orders = 0;
	float Revenue = 0;
	float Spend = 0;
	float A_x0020_to_x0020_S = 0;
	
	for (int i=1; i<=[[NSString stringWithFormat:@"%@",self.Date_Count] intValue]; i++) 
	{
		NSDate *temp_dt_1 = [[self dateWithDaysBeforeNow:i]copy];
		NSString *temp_str_1=[dateFormatter stringFromDate:temp_dt_1];	
		
		for (int j = 0; j < [D_S_Arr count]; j++) {
			
			NSString *d_str = [[D_S_Arr objectAtIndex:j] valueForKey:@"Date"];
			NSString *S_str = [[D_S_Arr objectAtIndex:j]valueForKey:@"Site"];
			
			if ([self.Site_Name isEqualToString:@"ALL SITE"]) {
				if ([temp_str_1 isEqualToString:d_str]) {
					
					int t_Clicks = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Clicks"]] intValue];
					Clicks = Clicks + t_Clicks;
					
					int t_Orders = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Orders"]] intValue];
					Orders = Orders + t_Orders;
					
					float t_Revenue = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Revenue"]] floatValue];
					Revenue = Revenue + t_Revenue;
					
					float t_Spend = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Spend"]] floatValue];
					Spend = Spend + t_Spend;
					
					if(![[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"] isEqualToString:@"NaN"])
					{
						
						float t_A_x0020_to_x0020_S = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"]] floatValue];
						A_x0020_to_x0020_S = A_x0020_to_x0020_S + t_A_x0020_to_x0020_S;
						
					}
				}
			}else
			{
				if ([self.Site_Name isEqualToString:S_str] && [temp_str_1 isEqualToString:d_str]) {
					
					int t_Clicks = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Clicks"]] intValue];
					Clicks = Clicks + t_Clicks;
					
					int t_Orders = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Orders"]] intValue];
					Orders = Orders + t_Orders;
					
					float t_Revenue = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Revenue"]] floatValue];
					Revenue = Revenue + t_Revenue;
					
					float t_Spend = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"Spend"]] floatValue];
					Spend = Spend + t_Spend;
					
					if(![[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"] isEqualToString:@"NaN"])
					{
						
						float t_A_x0020_to_x0020_S = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"]] floatValue];
						A_x0020_to_x0020_S = A_x0020_to_x0020_S + t_A_x0020_to_x0020_S;
						
					}
				}
			}
		}
	}
	NSMutableDictionary *t_dict = [[NSMutableDictionary alloc]init];
	[t_dict setObject:[NSString stringWithFormat:@"%d",Clicks] forKey:@"Clicks"];
	[t_dict setObject:[NSString stringWithFormat:@"%d",Orders] forKey:@"Orders"];
	[t_dict setObject:[NSString stringWithFormat:@"%f",Revenue] forKey:@"Revenue"];
	[t_dict setObject:[NSString stringWithFormat:@"%f",Spend] forKey:@"Spend"];
	[t_dict setObject:[NSString stringWithFormat:@"%f",A_x0020_to_x0020_S] forKey:@"A_x0020_to_x0020_S"];
	
	s_click.text = [NSString stringWithFormat:@"%d",Clicks];
	s_order.text = [NSString stringWithFormat:@"%d",Orders];
	s_revenue.text = [NSString stringWithFormat:@"$ %.2f",Revenue];
	s_gross.text = [NSString stringWithFormat:@"$ %.2f",Spend];
	
	int date = [[NSString stringWithFormat:@"%@",self.Date_Count] intValue]; 
	s_atos.text = [NSString stringWithFormat:@"%.2f %@",(A_x0020_to_x0020_S/date)*100,@"%"];
}


- (NSString *)decodeHTMLEntities:(NSString *)string {
	// Reserved Characters in HTML 
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@"_x0020_"];
	string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"_x0027_"];
	string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"_x0026_"];
	string = [string stringByReplacingOccurrencesOfString:@"," withString:@"_x002C_"];
	
	return string;
}



#pragma mark filter_Detail_data

-(void)filter_Detail_data
{
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSDate *now = [NSDate date];
	NSString *str=[[NSString	alloc]init];
	str=[dateFormatter stringFromDate:now];
	
	if ([self.Cat_Name isEqualToString:@"Gross Spend"]) {
		self.Cat_Name = @"Spend";
	}
	
	if ([self.Cat_Name isEqualToString:@"A to S"]) {
		self.Cat_Name = @"A_x0020_to_x0020_S";
	}
	
	
	NSMutableArray *t_arr = [[NSMutableArray alloc]init];
	
	NSMutableArray *t_arr_graph = [[NSMutableArray alloc]init];
	
	for (int i=1; i<=[[NSString stringWithFormat:@"%@",self.Date_Count] intValue]; i++) 
	{
		float val = 0;
		
		NSDate *temp_dt_1 = [[self dateWithDaysBeforeNow:i]copy];
		NSString *temp_str_1=[dateFormatter stringFromDate:temp_dt_1];	
		
		for (int j = 0; j < [D_S_Arr count]; j++) {
			
			NSString *d_str = [[D_S_Arr objectAtIndex:j] valueForKey:@"Date"];
			NSString *S_str = [[D_S_Arr objectAtIndex:j]valueForKey:@"Site"];
			
			
			if ([self.Site_Name isEqualToString:@"ALL SITE"]) {
				if ([temp_str_1 isEqualToString:d_str]) {
					
					float t_val = 0.0;
					
					if (![self.Cat_Name isEqualToString:@"A_x0020_to_x0020_S"]) 
					{
						t_val = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:self.Cat_Name]] intValue];
					}
					else
					{
						if(![[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"] isEqualToString:@"NaN"])
						{
							t_val = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"]] floatValue] * 100;
						}
					}
					val = val + t_val;
				}
			}
			else
			{
				if ([self.Site_Name isEqualToString:S_str] && [temp_str_1 isEqualToString:d_str]) {
					
					float t_val;
					
					if (![self.Cat_Name isEqualToString:@"A_x0020_to_x0020_S"]) 
					{
						t_val = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:self.Cat_Name]] intValue];
					}
					else
					{
						if(![[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"] isEqualToString:@"NaN"])
						{
							t_val = [[NSString stringWithFormat:@"%@",[[D_S_Arr objectAtIndex:j]valueForKey:@"A_x0020_to_x0020_S"]] floatValue] * 100;
						}
					}
					val = val + t_val;
				}
			}
		}
		NSMutableDictionary *t_dict1 = [[NSMutableDictionary alloc]init];
		
		NSMutableDictionary *t_dict2 = [[NSMutableDictionary alloc]init];
		
		if ([self.Cat_Name isEqualToString:@"Clicks"]) 
		{
			[t_dict1 setObject:[NSString stringWithFormat:@"%.0f",val] forKey:@"val"];
			[t_dict1 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
			
			[t_dict2 setObject:[NSString stringWithFormat:@"%.0f",val] forKey:@"val"];
			[t_dict2 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
		}
		else
		if ([self.Cat_Name isEqualToString:@"Orders"]) 
		{
			[t_dict1 setObject:[NSString stringWithFormat:@"%.0f",val] forKey:@"val"];
			[t_dict1 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
			
			[t_dict2 setObject:[NSString stringWithFormat:@"%.0f",val] forKey:@"val"];
			[t_dict2 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
		}
		else
		if ([self.Cat_Name isEqualToString:@"Spend"]) 
		{
			[t_dict1 setObject:[NSString stringWithFormat:@"$ %.0f",val] forKey:@"val"];
			[t_dict1 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
			
			[t_dict2 setObject:[NSString stringWithFormat:@"%.0f",val] forKey:@"val"];
			[t_dict2 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
		}
		else
		if ([self.Cat_Name isEqualToString:@"Revenue"]) 
		{
			[t_dict1 setObject:[NSString stringWithFormat:@"$ %.0f",val] forKey:@"val"];
			[t_dict1 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
			
			[t_dict2 setObject:[NSString stringWithFormat:@"%.0f",val] forKey:@"val"];
			[t_dict2 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
		}
		else
		if ([self.Cat_Name isEqualToString:@"A_x0020_to_x0020_S"]) 
		{
			
			//val = val * 100;
			[t_dict1 setObject:[NSString stringWithFormat:@"%.2f %@",val,@"%"] forKey:@"val"];
			[t_dict1 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
			
			[t_dict2 setObject:[NSString stringWithFormat:@"%.2f",val] forKey:@"val"];
			[t_dict2 setObject:[NSString stringWithFormat:@"%@",temp_str_1] forKey:@"date"];
		}
		[t_arr addObject:t_dict1];
		[t_arr_graph addObject:t_dict2];
	}

	self.myDetailDataArray = [t_arr copy];
	[t_arr release];
	
	self.myDetailDataArray_graph = [t_arr_graph copy];
	[t_arr_graph release];
	
	[subsegmnttable reloadData];
	[self Core_plot_draw];
	
}


#pragma mark Site Button Clicked

-(void)selectSite:(id)sender
{
	
	UIButton *btn = (UIButton*)sender;
	if (btn.tag == 1) {
		SiteAndCatFlag = 5;
		[SiteForRealData showAlert:realtime_site_arr siteName:self.navigationItem.rightBarButtonItem.title delegate:self];
	}else 
	if(btn.tag == 2) {
		SiteAndCatFlag = 1;
		[SiteForRealData showAlert:realtime_site_arr siteName:self.navigationItem.rightBarButtonItem.title delegate:self];
	}
}


#pragma mark Data Button Clicked

-(IBAction)selectSDataFilter:(id)sender
{
	SiteAndCatFlag = 2;
	[SiteForRealData showAlert:myMartixDetailArr siteName:matrics_btndetail.titleLabel.text delegate:self];
}


#pragma mark Real Data Button Clicked

-(IBAction)selectRealDataFilter:(id)sender
{
	SiteAndCatFlag = 4;
	[SiteForRealData showAlert:myMartixRealArr siteName:matrics_btn.titleLabel.text delegate:self];
}

#pragma mark Date Button Clicked

-(IBAction)select_day_btn_clicked:(id)sender
{
	day_btn1.selected = FALSE;
	day_btn2.selected = FALSE;
	day_btn3.selected = FALSE;
	
	UIButton *btn = (UIButton*)sender;
	NSString *t_date_count = [[NSString alloc]init];
	t_date_count = [NSString stringWithFormat:@"%d",btn.tag];
	self.Date_Count = [t_date_count copy];
	[t_date_count release];
	
	if (btn.tag == 8) {
		day_btn1.selected = TRUE;
	}else if (btn.tag == 31) {
		day_btn2.selected = TRUE;
	}else if (btn.tag == 61) {
		day_btn3.selected = TRUE;
	}
	[self filter_summary_data];
	[self filter_Detail_data];
}



- (NSString *)convertDateString:(NSString *)dateString toDateFormat:(NSString *)format {
	
	[formatter0000 setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [[formatter0000 dateFromString:dateString] copy];
	[formatter0000 setDateFormat:[format copy]];
	return [formatter0000 stringFromDate:date];
}

-(void)connectionError:(NSError*)err{
	//[AlertHandler hideAlert];
	[self hideHUD];
}





#pragma mark -
#pragma mark segmented Control Style

-(IBAction)segmentedControlIndexChanged
{
	
	switch(mysegment.selectedSegmentIndex) 
	{
		case 0:
			realtimeview.hidden = FALSE;
            detailview.hidden = TRUE;
            summaryview.hidden = TRUE;
			dateView.hidden = TRUE;
			
			//[self filter_realTime_data];
			[self performSelector:@selector(filter_realTime_data) withObject:nil afterDelay:0.01];
			
			self.navigationItem.rightBarButtonItem.tag = 1;
			
			break;
            
            
		case 1:
            realtimeview.hidden = TRUE;
            detailview.hidden = FALSE;
            summaryview.hidden = TRUE;
            dateView.hidden = FALSE;
            [mysubsegment setSelectedSegmentIndex:0];
            
            subgraphview.hidden = FALSE;
            subtableview.hidden = TRUE;
		
			self.navigationItem.rightBarButtonItem.tag = 2;
			
			
			site_name_lbl.text = self.Site_Name;
			
			[self performSelector:@selector(filter_Detail_data) withObject:nil afterDelay:0.01];
			
			
		
			break;
            
        case 2:
            realtimeview.hidden = TRUE;
            detailview.hidden = TRUE;
            summaryview.hidden = FALSE;
            dateView.hidden = FALSE;
						
			self.navigationItem.rightBarButtonItem.tag = 2;
			
			site_name_lbl.text = self.Site_Name;
			
			[self performSelector:@selector(filter_summary_data) withObject:nil afterDelay:0.01];
			
			
			break;
	}
}


#pragma mark -
#pragma mark Sub-Segmented Control Style

-(IBAction)subsegmentedControlIndexChanged
{
    switch(mysubsegment.selectedSegmentIndex) 
	{
		case 0:
            subgraphview.hidden = FALSE;
            subtableview.hidden = TRUE;
			break;
            
		case 1:
            subgraphview.hidden = TRUE;
            subtableview.hidden = FALSE;
			break;
    }
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myDetailDataArray count]-1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	CustomDetailLbl *cell = [CustomDetailLbl dequeOrCreateInTable:tableView];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	cell.Date_lbl.text = [NSString stringWithFormat:@"%@",[[self.myDetailDataArray objectAtIndex:indexPath.row+1] valueForKey:@"date"]];
	cell.value_lbl.text = [NSString stringWithFormat:@"%@",[[self.myDetailDataArray objectAtIndex:indexPath.row+1] valueForKey:@"val"]];
	
	cell.value_lbl.layer.borderColor = [UIColor blackColor].CGColor;
	cell.value_lbl.layer.borderWidth = 1;
	
	cell.Date_lbl.layer.borderColor = [UIColor blackColor].CGColor;
	cell.Date_lbl.layer.borderWidth = 1;
	
	return cell;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

-(NSDate *)dateWithDaysBeforeNow:(NSUInteger)days
{
	NSTimeInterval aTimeInterval = [[NSDate date]timeIntervalSinceReferenceDate] - 86400 * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

-(NSString *)dateWithHourBeforeNow:(int)hours
{
	NSDate *date = [NSDate date];
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateFormat = @"M/d/yyyy";
	NSString * str= [dateFormatter stringFromDate:date];
	NSDate *refDate = [dateFormatter dateFromString:str];
	refDate = [refDate dateByAddingTimeInterval:3600*hours];
	NSDateFormatter* dateFormatter123 = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter123.dateFormat = @"M/d/yyyy h:mm:ss a";
	
	NSString * str2= [dateFormatter123 stringFromDate:refDate];	
	
	return str2;
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



-(void)Core_plot_For_RealTime
{
	NSTimeInterval oneDay = 60*60;
	NSTimeInterval xLow = 0.0f;
	
	if (real_symbolTextAnnotation) {
        [Real_graph.plotAreaFrame.plotArea removeAnnotation:real_symbolTextAnnotation];
        real_symbolTextAnnotation = nil;
		[real_symbolTextAnnotation release];
    }
	
	if (myformater_arr) {
		myformater_arr = nil;
		[myformater_arr release];
	}
	
	myformater_arr =[[NSMutableArray alloc]init];
	float range1 = 1.0;
	
	for (int i = 0; i < [self.RealTime_SortArr count]; i++ ) {
		NSTimeInterval x = oneDay*i;
		id y = [NSDecimalNumber numberWithFloat:[[[self.RealTime_SortArr objectAtIndex:i] valueForKey:@"val"] floatValue]];
		[myformater_arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber numberWithFloat:x], [NSNumber numberWithInt:CPTScatterPlotFieldX], y, [NSNumber numberWithInt:CPTScatterPlotFieldY],nil]];
		float range2 = [[[self.RealTime_SortArr objectAtIndex:i] valueForKey:@"val"] floatValue];
		if (range2 > range1) {
			range1 = range2;
		}
	}
	
	
	NSString *temp_str_1 = [self dateWithHourBeforeNow:0];
			
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = kCFDateFormatterNoStyle;
	[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
	NSDate *refDate1 = [formatter dateFromString:temp_str_1];
	[formatter setDateFormat:@"h a"];
	//NSString * str= [formatter stringFromDate:refDate1];
//	[formatter setDateFormat:@"hh a"];	
//	NSDate *refDate = [formatter dateFromString:str];
	//Real_timeFormatter.referenceDate = refDate;
	
	//NSDateFormatter *dateFormatter123 = [[[NSDateFormatter alloc] init] autorelease];
    //formatter.dateStyle = kCFDateFormatterShortStyle;
	//[formatter setDateFormat:@"hh a"];
    CPTTimeFormatter *timeFormatter111 = [[[CPTTimeFormatter alloc] initWithDateFormatter:formatter] autorelease];
    timeFormatter111.referenceDate = refDate1;
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)Real_graph.defaultPlotSpace;
	 plotSpace.delegate = self;
	plotSpace.allowsUserInteraction = YES;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneDay*[self.RealTime_SortArr count]>0?oneDay*[self.RealTime_SortArr count]:oneDay)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(range1)];
	
	CPTPlotRange *yRange = plotSpace.yRange;
	CPTPlotRange *xRange = plotSpace.xRange;
    [yRange expandRangeByFactor:CPTDecimalFromDouble(1.3)];
    plotSpace.yRange = yRange;
	[xRange expandRangeByFactor:CPTDecimalFromDouble(1.3)];
    plotSpace.xRange = xRange;
	
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)Real_graph.axisSet;
	CPTXYAxis *x = axisSet.xAxis;
	x.title = @"Hour";
	x.titleOffset = 18.0f;
	x.labelFormatter = timeFormatter111;
	x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	x.majorIntervalLength = CPTDecimalFromFloat(oneDay);
	x.minorTickLength = 2;
	
	x.minorTicksPerInterval = 4.0f;
	x.minorTickLength = 5.0f;
    x.majorTickLength = 7.0f;

	
	x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); //added for date, adjust x line
	
		//x.timeOffset=60;


	
	CPTXYAxis *y = axisSet.yAxis;
	y.title = [NSString stringWithFormat:@"%@",matrics_btn.titleLabel.text];
	y.titleOffset = 18.0f;
	y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	
	
	
	/* Custom labels
	
	
	//x.labelRotation = M_PI/4;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:0],
									[NSDecimalNumber numberWithInt:5000], 
									[NSDecimalNumber numberWithInt:10000], 
									[NSDecimalNumber numberWithInt:15000],
									[NSDecimalNumber numberWithInt:20000],
									[NSDecimalNumber numberWithInt:25000],
									[NSDecimalNumber numberWithInt:30000],
									[NSDecimalNumber numberWithInt:35000],
									[NSDecimalNumber numberWithInt:40000],
									[NSDecimalNumber numberWithInt:45000],
									[NSDecimalNumber numberWithInt:50000],
									[NSDecimalNumber numberWithInt:55000],
									[NSDecimalNumber numberWithInt:60000],
									[NSDecimalNumber numberWithInt:65000],
									[NSDecimalNumber numberWithInt:70000],
									[NSDecimalNumber numberWithInt:75000],
									[NSDecimalNumber numberWithInt:80000],
									[NSDecimalNumber numberWithInt:85000],
									[NSDecimalNumber numberWithInt:90000],
									[NSDecimalNumber numberWithInt:95000],
									[NSDecimalNumber numberWithInt:100000],
									[NSDecimalNumber numberWithInt:105000],
									[NSDecimalNumber numberWithInt:110000],
									[NSDecimalNumber numberWithInt:115000],
									nil];
	NSArray *xAxisLabels = [NSArray arrayWithObjects:@"12 AM", @"1 AM", @"2 AM", @"3 AM", @"4 AM", @"5 AM", @"6 AM", @"7 AM", @"8 AM", @"9 AM", @"10 AM", @"11 AM", @"12 PM", @"1 PM", @"2 PM", @"3 PM", @"4 PM", @"5 PM", @"6 PM", @"7 PM", @"8 PM", @"9 PM", @"10 PM", @"11 PM", nil];
	NSUInteger labelLocation = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for (NSNumber *tickLocation in customTickLocations) {
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset = x.labelOffset + x.majorTickLength;
		//newLabel.rotation = M_PI/4;
		[customLabels addObject:newLabel];
		[newLabel release];
	}
	
	x.axisLabels =  [NSSet setWithArray:customLabels];

	*/
	

	[Real_graph reloadData];
}



-(void)Core_plot_draw
{
	NSTimeInterval oneDay = 24 * 60 * 60;
	NSTimeInterval xLow = 0.0f;

	
	if (symbolTextAnnotation) {
        [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
        symbolTextAnnotation = nil;
		[symbolTextAnnotation release];
    }
	
	if (myformater_arr) {
		myformater_arr = nil;
		[myformater_arr release];
	}
	
	

	
	myformater_arr =[[NSMutableArray alloc]init];
	float range1 = 1.0;
	int z = [self.myDetailDataArray_graph count];
	
	for (int i = 0; i < [self.myDetailDataArray_graph count]; i++ ) {
		NSTimeInterval x = oneDay*z;
		z--;
		id y = [NSDecimalNumber numberWithFloat:[[[self.myDetailDataArray_graph objectAtIndex:i] valueForKey:@"val"] floatValue]];
		[myformater_arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber numberWithFloat:x], [NSNumber numberWithInt:CPTScatterPlotFieldX], y, [NSNumber numberWithInt:CPTScatterPlotFieldY],nil]];
		float range2 = [[[self.myDetailDataArray_graph objectAtIndex:i] valueForKey:@"val"] floatValue];
		if (range2 > range1) {
			range1 = range2;
		}
	}
	
	[myformater_arr removeObjectAtIndex:0];
	
	NSString *str1 = [[self.myDetailDataArray_graph objectAtIndex:[self.myDetailDataArray_graph count]-1] valueForKey:@"date"];
	NSArray *arr1 = [str1 componentsSeparatedByString:@"-"];
	NSString *yy = [arr1 objectAtIndex:0];
	NSString *mm = [arr1 objectAtIndex:1];
	NSString *dd = [arr1 objectAtIndex:2];
	
	NSString *dtStr = [NSString stringWithFormat:@"%@-%@-%@",yy,mm,dd];		
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSDate *refDate = [formatter dateFromString:dtStr];
	refDate = [refDate addTimeInterval:-1.0];
	
	
	NSDateFormatter *dateFormatter123 = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter123.dateStyle = kCFDateFormatterNoStyle;
	[dateFormatter123 setDateFormat:@"MMM dd"];
    CPTTimeFormatter *timeFormatter111 = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter123] autorelease];
    timeFormatter111.referenceDate = refDate;
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
	 plotSpace.delegate = self;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneDay*[self.myDetailDataArray_graph count])];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(range1)];
	
	CPTPlotRange *yRange = plotSpace.yRange;
	CPTPlotRange *xRange = plotSpace.xRange;
    [yRange expandRangeByFactor:CPTDecimalFromDouble(1.3)];
    plotSpace.yRange = yRange;
	[xRange expandRangeByFactor:CPTDecimalFromDouble(1.4)];
    plotSpace.xRange = xRange;
	
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x = axisSet.xAxis;
	CPTXYAxis *y = axisSet.yAxis;
	x.title = @"Date";
	y.title = [NSString stringWithFormat:@"%@",matrics_btndetail.titleLabel.text];
	x.titleOffset = 15.0f;
	y.titleOffset = 18.0f;
	
	 x.labelFormatter = timeFormatter111;
	
	[graph reloadData];
}

//-(CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement {
//    return CGPointMake(space.graph., space.graph.axisSet.frame.origin.y);
//}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return [myformater_arr count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSString *str = [NSString stringWithFormat:@"DataPlot"];
	if ([plot.identifier isEqual:str])
	{
		NSDecimalNumber *num = [[myformater_arr objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
		return num;
	}
	return nil;
}



#pragma mark -
#pragma mark CPTScatterPlot delegate method

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    
	
    if (symbolTextAnnotation) {
        [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
        symbolTextAnnotation = nil;
		[symbolTextAnnotation release];
    }
	
	if (real_symbolTextAnnotation) {
        [Real_graph.plotAreaFrame.plotArea removeAnnotation:real_symbolTextAnnotation];
        real_symbolTextAnnotation = nil;
		[real_symbolTextAnnotation release];
    }
	
    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color = [CPTColor whiteColor];
    hitAnnotationTextStyle.fontSize = 14.0f;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
	
    // Determine point of symbol in plot coordinates
	
    NSNumber *x = [[myformater_arr objectAtIndex:index] objectForKey:[NSNumber numberWithInt:1]];
    NSNumber *y = [[myformater_arr objectAtIndex:index] objectForKey:[NSNumber numberWithInt:0]];
    NSArray *anchorPoint = [NSArray arrayWithObjects:y,x, nil];
	
    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:x];
	
    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle];
    symbolTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    symbolTextAnnotation.contentLayer = textLayer;
    symbolTextAnnotation.displacement = CGPointMake(0.0f, 20.0f);
    [graph.plotAreaFrame.plotArea addAnnotation:symbolTextAnnotation];    
	
	CPTTextLayer *textLayer2 = [[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle];
	real_symbolTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:Real_graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    real_symbolTextAnnotation.contentLayer = textLayer2;
    real_symbolTextAnnotation.displacement = CGPointMake(0.0f, 20.0f);
    [Real_graph.plotAreaFrame.plotArea addAnnotation:real_symbolTextAnnotation];
}



-(void)viewDidDisappear:(BOOL)animated
{
	[self.u_name release];
	[self.u_pwd release];
	[self.webService release];
	[self.clientname release];
	
	[self.RealTime_SortArr release];
	[self.myDetailDataArray release];
	[self.myDetailDataArray_graph release];
	
	[D_S_Arr release];
	[realtimeArr release];
	[realtime_site_arr release];
	[D_S_site_arr release];
	[myMartixDetailArr release];
	[myMartixRealArr release];
	[myDetailDataArray release];
	[refreshArray release];
	
	
	formatter0000 = nil;
	[formatter0000 release];
}


-(void)back_btn_clicked
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

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
	
	
}

@end



