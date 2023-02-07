//
//  JTECGManagerMemoryModel.h
//  BluetoothDemo
//
//  Created by sky on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTECGManagerMemoryModel : NSObject
/**
 心率 bmp
 
 Heart rate bmp
 */
@property (nonatomic, assign) NSInteger heartRate;

/**
 心跳 bmp
 
 Heart rate bmp
 */
@property (nonatomic, copy) NSString *heartBeat;

@end

NS_ASSUME_NONNULL_END
