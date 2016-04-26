

#import "CustomStoreObserver.h"


@implementation CustomStoreObserver
@synthesize paymentDelegate;


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	NSLog(@"error\%@",[transaction.error description]);
	NSLog(@"local desc=%@",[transaction.error localizedDescription]);
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		// Optionally, display an error here.
		
	}
	if([paymentDelegate respondsToSelector:@selector(paymentTransactionFail)])
	   [paymentDelegate paymentTransactionFail];
	
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	//If you want to save the transaction
	// [self recordTransaction: transaction];
	
	//Provide the new content
	// [self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
	//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	if([paymentDelegate respondsToSelector:@selector(completePaymentTransaction)])
	   [paymentDelegate completePaymentTransaction];
	   
	
	
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	//If you want to save the transaction
	// [self recordTransaction: transaction];
	
	//Provide the new content
	//[self provideContent: transaction.payment.productIdentifier];
	
	if([paymentDelegate respondsToSelector:@selector(completePaymentTransaction)])
	   [paymentDelegate completePaymentTransaction];
	   
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)buyProduct:(NSString*)productIdentifier{
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
	  
-(void)dealloc{
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	[super dealloc];
}
@end
