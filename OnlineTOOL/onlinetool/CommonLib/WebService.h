

#import <Foundation/Foundation.h>
#import "TouchXML.h"
@protocol WebServiceDelegate;





@interface WebService : NSObject 
{
	id<WebServiceDelegate> _delegate; 
	
	NSMutableData *mydata;
	NSMutableDictionary *dict;
	NSURLConnection *conections;
}

@property (nonatomic , assign) id<WebServiceDelegate> _delegate; 

-(id)initWithDelegate:(id)sender;
-(void) callWebSetvice:(NSString *) strRequest withSoapAction:(NSString*)soapAction;
-(CXMLNode*)nodeForXPath:(NSString*)xPath MainNode:(CXMLNode*)node nameSpace:(NSMutableDictionary*)nameDict Error:(NSError**)error;
-(NSArray*)nodesForXPath:(NSString*)xPath MainNode:(CXMLNode*)node nameSpace:(NSMutableDictionary*)nameDict Error:(NSError**)error;
-(NSString*)stringForXPath:(NSString*)xPath MainNode:(CXMLNode*)node nameSpace:(NSMutableDictionary*)nameDict Error:(NSError**)error;
-(NSMutableDictionary*)nameSpace;
-(void)setNameSpace:(NSMutableDictionary*)nameDict;
-(void)cancelAllOperation;
-(NSMutableDictionary*)nameSpace;
@end


@protocol WebServiceDelegate <NSObject >


@optional
-(void)connectionFinish:(NSString*)strResponse;
-(void)webservice:(WebService*)ser finishWithResponse:(NSString*)strResponse;
-(void)connectionError:(NSError*)err;


@end



