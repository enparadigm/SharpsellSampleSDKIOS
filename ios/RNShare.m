//
//  RNShare.m
//  SharpsellSampleSDKIOS
//
//  Created by Surya on 30/01/24.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNShare, NSObject)

RCT_EXTERN_METHOD(createSharpsellEngine:(NSDictionary *)options)

RCT_EXTERN_METHOD(open:(NSDictionary *)options)
RCT_EXTERN_METHOD(initilizeSharpsell:(NSDictionary *)options)
RCT_EXTERN_METHOD(logoutSharpsell:(NSDictionary *)options)


@end
