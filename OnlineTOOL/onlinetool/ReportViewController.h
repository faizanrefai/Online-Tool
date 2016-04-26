//
//  ReportViewController.h
//  onlinetool
//
//  Created by apple on 9/24/11.
//  Copyright 2011 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onlinetoolAppDelegate.h"
#import "AlertHandler.h"
#import "WebService.h"
#import "ReportCustomCell.h"
#import "DetailCustomCell.h"
#import "MBProgressHUD.h"
#import "SiteForRealData.h"
#import "CustomDetailLbl.h"
#import "CorePlot-CocoaTouch.h"
#import "TestXYTheme.h"



@interface ReportViewController : UIViewController <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate , UITableViewDelegate , UITableViewDataSource , CPTPlotDataSource> {
    
	MBProgressHUD *HUD;
    
    IBOutlet UIView *realtimeview;
    IBOutlet UIView *detailview;
    IBOutlet UIView *summaryview;
    
    IBOutlet UIView *subgraphview;
    IBOutlet UIView *subtableview;
	
	IBOutlet UIView *dateView;
    
    IBOutlet UISegmentedControl *mysegment;
    IBOutlet UISegmentedControl *mysubsegment;
    
    IBOutlet UITableView *subsegmnttable;
    IBOutlet UITableView *segmnttable;
    
   
	IBOutlet UIButton *site_btn;
	IBOutlet UIButton *date_btn;
	IBOutlet UIButton *matrics_btn;
	IBOutlet UIButton *matrics_btndetail;
	
	
	BOOL isDetail;
    
	NSString *u_name;
	NSString *clientname;
	NSString *u_pwd;
	
	NSString *Site_Name;
	NSString *Date_Count;
	NSString *Cat_Name;
	
	
	WebService *webService;
	
	onlinetoolAppDelegate *appDelegate;
	
	NSMutableArray *D_S_Arr;
	NSMutableArray *realtimeArr;
	
	NSMutableArray *realtime_site_arr;
	NSMutableArray *D_S_site_arr;
	
	NSMutableArray *myMartixDetailArr;
	
	NSMutableArray *myMartixRealArr;
	
	NSMutableArray *myDetailDataArray;
	
	NSMutableArray *refreshArray;
	
	BOOL CgetSitesflag;
	
	IBOutlet UIButton *day_btn1;
	IBOutlet UIButton *day_btn2;
	IBOutlet UIButton *day_btn3;
	
	IBOutlet UILabel *s_click;
	IBOutlet UILabel *s_order;
	IBOutlet UILabel *s_revenue;
	IBOutlet UILabel *s_gross;
	IBOutlet UILabel *s_atos;
	
	
	NSDateFormatter *formatter0000;
	
	int SiteAndCatFlag;
	
	IBOutlet UILabel *site_name_lbl;
	IBOutlet UILabel *date_name_lbl;
	
	int refreshTime;
	NSString *refreshStr;
	
	UILabel *lbl1;
	UILabel *lbl2;
	
	NSTimer *timer;
	
	NSMutableArray *myDetailDataArray_graph;
	
	
	IBOutlet CPTGraphHostingView *hostingGraphView;
	CPTXYGraph *graph;
	
	
	
	IBOutlet CPTGraphHostingView *Real_hostingGraphView;
	CPTXYGraph *Real_graph;
	////////core-plot//////

	
	NSMutableArray *myformater_arr;
	
	//NSMutableArray *dataForPlotFb;
//	NSMutableArray *dataForPlotGoogle;
//	NSMutableArray *dataForPlotGoogleCOnt;
//	NSMutableArray *dataForPlotMsn;
    int pointsCountMinusStartingPoint;  
    int intYNumberOfCharacters; 
	//CPTGraphHostingView *hostingView;
	//NSMutableArray *arrXvalues;
	CPTLayerAnnotation   *symbolTextAnnotation;
	
	CPTLayerAnnotation   *real_symbolTextAnnotation;
	
	NSMutableArray *RealTime_SortArr;
	NSString *RealCatName;
	
}
-(NSDate *)dateWithDaysBeforeNow:(NSUInteger)days;


@property (nonatomic, retain) NSMutableArray *RealTime_SortArr;
@property (nonatomic, retain) NSString *RealCatName;
@property (nonatomic, retain) NSString *u_name;
@property (nonatomic, retain) NSString *clientname;
@property (nonatomic, retain) NSString *u_pwd;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSString *Site_Name;
@property (nonatomic, retain) NSString *Date_Count;
@property (nonatomic, retain) NSString *Cat_Name;
@property (nonatomic, retain) NSString *refreshStr;

@property (nonatomic, retain) NSMutableArray *myDetailDataArray;
@property (nonatomic, retain) NSMutableArray *myDetailDataArray_graph;

-(void)CgetDailyPerformanceData;
-(void)CgetDailyPerformanceDataWS;
-(void)setValueUname:(NSString*)uname Pwd:(NSString*)pwd Client:(NSString*)client;
-(void)CgetRealTimePerformanceDataWS;


-(IBAction)selectSDataFilter:(id)sender;
-(IBAction)select_day_btn_clicked:(id)sender;

-(IBAction)segmentedControlIndexChanged;
-(IBAction)subsegmentedControlIndexChanged;

-(IBAction)refresh_btn_clicked:(id)sender;

-(void)change_site_name:(NSString*)name;
-(void)selectSite:(id)sender;

-(void)select_refresh:(NSString*)str;

-(void)filter_summary_data;
-(void)filter_Detail_data;

- (NSString *)convertDateString:(NSString *)dateString toDateFormat:(NSString *)format;

//-(void)sort_data;
-(void)showHUD;
-(void)hideHUD;

-(void)Core_plot_draw;

-(void)filter_realTime_data;

-(NSString *)dateWithHourBeforeNow:(int)hours;

-(IBAction)selectRealDataFilter:(id)sender;


-(void)Core_plot_For_RealTime;
-(void)real_graph_view;

- (NSString *)decodeHTMLEntities:(NSString *)string;

@end


