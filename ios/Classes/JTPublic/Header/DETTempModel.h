//
//  DETTempModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DETTempModel : NSObject

/**
 温度计类型 1耳温;  2额温；3表示物温;
 Thermometer type 1 ear temperature; 2 forehead temperature; 3 means object temperature;
 */
@property (nonatomic, assign) NSInteger tempType;
/**
 温度单位   0摄氏温度 ℃ 1华氏温度 ℉
 Temperature unit 0 Celsius temperature ℃ 1 Fahrenheit temperature ℉
 */
@property (nonatomic, assign) NSInteger temperatureUnit;
/**
 温度
 temperature
 */
@property (nonatomic,copy) NSString *temperature;
/**
 时间戳
 Timestamp
 */
@property (nonatomic, strong) NSString *timesamp;
/**
 解析之前字16进制符串(sdk开发人员测试时使用)
 Parse the hexadecimal string of the previous word (used in internal debugging of the SDK)
 */
@property (nonatomic,copy) NSString *originalStr;


@end

NS_ASSUME_NONNULL_END
