//
//  applePay.m
//  TCLVBIMDemo
//
//  Created by 王敏欣 on 2016/12/2.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "applePay.h"
#import <StoreKit/StoreKit.h>
#import "Config.h"
@interface applePay ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic,strong) SKProductsRequest *request;
@property (nonatomic,strong) NSArray *products;
@property (nonatomic,strong) NSSet *productIdentifiers;
@property (nonatomic,strong) NSMutableSet *purchasedProducts;
@property (nonatomic,strong) SKProduct *product;
@property (nonatomic,copy) NSString *OrderNo;
@end
@implementation applePay
-(void)dealloc{
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

}
//内购开始
-(void)applePay:(NSDictionary *)dic{

    [self.delegate applePayShowHUD];
    NSDictionary *dics = @{
                          @"uid":[Config getOwnID],
                          @"coin":[dic valueForKey:@"coin_ios"],
                          @"money":[dic valueForKey:@"money"],
                          @"changeid":dic[@"id"]
                          };
    [WYToolClass postNetworkWithUrl:@"Charge.getIosOrder" andParameter:dics success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSString *infos = [[info firstObject] valueForKey:@"orderid"];
            self.OrderNo = infos;//订单
            //苹果支付ID
            NSString *setStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"product_id"]];
            NSSet *set = [[NSSet alloc] initWithObjects:setStr, nil];
            self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
            self.request.delegate = self;
            [self.request start];
            
        }
        else{
            [self.delegate applePayHUD];
            [MBProgressHUD showError:msg];
        }

    } fail:^{
        
    }];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
   
    [self.delegate applePayHUD];
    
    self.products = response.products;
    self.request = nil;
    for (SKProduct *product in response.products) {
        NSLog(@"已获取到产品信息 %@,%@,%@",product.localizedTitle,product.localizedDescription,product.price);
        self.product = product;
    }
    if (!self.product) {
        [self showAlertView:@"无法获取商品信息"];
        return;
    }
    //3.获取到产品信息，加入支付队列
    SKPayment *payment = [SKPayment paymentWithProduct:self.product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // Optional: Record the transaction on the server side...
    //记录当前购买成功的商品
    // NSLog(@"recordTransaction");
}
- (void)provideContent:(NSString *)productIdentifier {
    // NSLog(@"provideContent %@", productIdentifier);
    //针对购买的商品，提供不同的服务。
    [_purchasedProducts addObject:productIdentifier];
}
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
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"completeTransaction...");
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [self verifyReceipt:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
#pragma mark 服务器验证购买凭据
- (void) verifyReceipt:(SKPaymentTransaction *)transaction
{
    
    //苹果：域名+/Appapi/Pay/notify_ios
    [self.delegate applePayHUD];
    NSURL *url = [NSURL URLWithString:[h5url stringByAppendingFormat:@"/Appapi/Pay/notify_ios"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSData *transData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    NSString *encodeStr = [transData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
    //NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];version
    //NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *build = [NSString stringWithFormat:@"%@",app_build];

    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\",\"version_ios\":%@,\"out_trade_no\" : \"%@\"}", encodeStr,build,self.OrderNo];
    //把bodyString转换为NSData数据
    NSData *bodyData = [payload dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];//把bodyString转换为NSData数据
    [request setHTTPBody:bodyData];
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (result == nil) {
       // [MBProgressHUD showError:@"验证失败"];
    }
    else
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if(dict==nil)
        {
             [MBProgressHUD showError:@"请查看网站是否开启了调试模式"];
            return;
        }
        if ([[dict valueForKey:@"status"] isEqual:@"success"]) {
          //比对字典中以下信息基本上可以保证数据安全
            
            [MBProgressHUD showError:@"充值成功"];
            [self.delegate applePaySuccess];
        }
        else
        {
            [MBProgressHUD showError:[dict valueForKey:@"info"]];
            
        }
    }
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self showAlertView:@"用户已恢复购买"];
    [MBProgressHUD hideHUDForView:self animated:YES];
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [MBProgressHUD hideHUDForView:self animated:YES];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [self showAlertView:transaction.error.localizedDescription];
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }else{
      
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void)showAlertView:(NSString *)message
{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContro addAction:cancleAction];
    [[MXBADelegate sharedAppDelegate].topViewController presentViewController:alertContro animated:YES completion:nil];
}
@end
