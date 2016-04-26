
#import "WebService.h"
#import "Constant.h"


@implementation WebService
@synthesize _delegate;

-(id)initWithDelegate:(id)sender{
	if(self = [super init]){
		self._delegate = sender;
	}
	return self;
}
-(void) callWebSetvice:(NSString *) strRequest withSoapAction:(NSString*)soapAction
{
	NSData *body = [strRequest dataUsingEncoding:NSUTF8StringEncoding];

	NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WebServiceURL]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	NSString *msgLength = [NSString stringWithFormat:@"%d",strRequest.length];
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
	[request addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	
	if (mydata) {
		[mydata release];
		mydata = nil;
	}
	conections = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	mydata = [[NSMutableData alloc] init];
}


-(void)cancelAllOperation{
	if (conections) {
		[conections cancel];
		[conections release];
		conections = nil;
	}
	self._delegate = nil;
}

-(void)dealloc{
	if (conections) {
		[conections cancel];
		[conections release];
		conections = nil;
	}
	if (mydata) {
		[mydata release];
		mydata = nil;
	}
	[super dealloc];
}
#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[mydata appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([_delegate respondsToSelector:@selector(connectionError:)]) 
	{
		[_delegate connectionError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *strResponse = [[NSString alloc] initWithData:mydata encoding:NSUTF8StringEncoding];	
	if ([_delegate respondsToSelector:@selector(connectionFinish:)]) 
		[_delegate connectionFinish:strResponse];
	
	if([_delegate respondsToSelector:@selector(webservice:finishWithResponse:)])
		[_delegate webservice:self finishWithResponse:strResponse];
	
	strResponse = nil;
	[strResponse release];
	
}
#pragma mark -
#pragma mark Touch XmlParser methods
#pragma mark -



-(CXMLNode*)nodeForXPath:(NSString*)xPath MainNode:(CXMLNode*)node nameSpace:(NSMutableDictionary*)nameDict Error:(NSError**)error{
	NSArray *array = [self nodesForXPath:xPath MainNode:node nameSpace:nameDict Error:error];
	if ([array count]!= 0 && array != nil) {
		return [array objectAtIndex:0];
	}
	return nil;
	
}
-(NSArray*)nodesForXPath:(NSString*)xPath MainNode:(CXMLNode*)node nameSpace:(NSMutableDictionary*)nameDict Error:(NSError**)error{
	return [node nodesForXPath:xPath namespaceMappings:nameDict error:error];
	
}
-(NSString*)stringForXPath:(NSString*)xPath MainNode:(CXMLNode*)node nameSpace:(NSMutableDictionary*)nameDict Error:(NSError**)error{
	//	NSArray *array = [self nodesForXPath:xPath MainNode:node namespaceMappings:nameDict Error:error];
	NSArray *array = [self nodesForXPath:xPath MainNode:node nameSpace:nameDict Error:error];
	NSString *retStr = nil;
	if ([array count]!= 0 && array != nil) {
		retStr = [[array objectAtIndex:0] stringValue];
	}
	return retStr;
}
-(NSMutableDictionary*)nameSpace{
	return dict;
}
-(void)setNameSpace:(NSMutableDictionary*)nameDict{
	dict = nameDict;
}


#pragma mark -



@end
