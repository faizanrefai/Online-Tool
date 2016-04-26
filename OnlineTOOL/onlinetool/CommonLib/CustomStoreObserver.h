
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol CustomStoreObserverDelegate;

@interface CustomStoreObserver : NSObject<SKPaymentTransactionObserver> {
	id<CustomStoreObserverDelegate> paymentDelegate;

}
@property (nonatomic, assign) id<CustomStoreObserverDelegate> paymentDelegate;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)failedTransaction: (SKPaymentTransaction *)transaction;
- (void)restoreTransaction: (SKPaymentTransaction *)transaction;
- (void)completeTransaction: (SKPaymentTransaction *)transaction;
- (void)buyProduct:(NSString*)productIdentifier;

@end

@protocol CustomStoreObserverDelegate <NSObject>
@optional
- (void)completePaymentTransaction;
- (void)paymentTransactionFail;
@end