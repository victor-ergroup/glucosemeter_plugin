//
//  JTSPOModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTSPOModel : NSObject

// 5个字节：血氧+脉率+PI+柱状图+波形 | 5 bytes: blood oxygen + pulse rate + PI + histogram + waveform
/**
 血氧
 Blood oxygen
 */
@property (nonatomic, copy) NSString *spo2;
/**
 脉率
 Pulse rate
 */
@property (nonatomic, copy) NSString *hr;
/**
PI
 */
@property (nonatomic, copy) NSString *pi;
/**
 柱状图
 Histogram
 */
@property (nonatomic, copy) NSString *histogram;
/**
 波形
 Wave
 */
@property (nonatomic, copy) NSString *wave;
/**
 时间戳
 timesamp
 */
@property (nonatomic, copy) NSString *timesamp;
/**
 年
 year
 */
@property (nonatomic, copy) NSString *year;
/**
 月份
 month
 */
@property (nonatomic, copy) NSString *month;
/**
 日期
 date
 */
@property (nonatomic, copy) NSString *day;
/**
 小时
 hour
 */
@property (nonatomic, copy) NSString *hour;
/**
 分钟
 minute
 */
@property (nonatomic, copy) NSString *minute;
/**
 秒
 second
 */
@property (nonatomic, copy) NSString *second;


@end

NS_ASSUME_NONNULL_END
