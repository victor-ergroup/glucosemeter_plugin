//
//  JTECGManagerRealModel.h
//  BluetoothDemo
//
//  Created by sky on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTECGManagerRealModel : NSObject

/**
 ff 响一次 00 不响
 */
@property (nonatomic, copy) NSString *sound; // ff：响一次

/**
 心率 bmp
 
 Heart rate bmp
 */
@property (nonatomic, assign) NSInteger heartRate;
/**
 心跳数组
 */
@property (nonatomic, strong) NSArray *heartBeats;

@end

NS_ASSUME_NONNULL_END
