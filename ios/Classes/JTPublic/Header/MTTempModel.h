//
//  MTTempModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTTempModel : NSObject

/**
 type 功能字
 
 04 获取温度值正常
 
 type function word
 
 04 Obtained temperature value is normal
 
 */
@property (nonatomic,copy) NSString *type;
/**
 温度  当测量值小于温度范围最小值时，显示Lo；当测量值大于温度范围最大值时，显示Hi；precision=0 返回华氏温度
 Temperature When the measured value is less than the minimum value of the temperature range, it displays Lo; when the measured value is greater than the maximum value of the temperature range, it displays Hi; precision=0 returns the temperature in Fahrenheit
 */
@property (nonatomic,copy) NSString *temperature;
/**
 精度 0 高精度 华氏温度  1低精度 摄氏温度
 Accuracy 0 High accuracy Fahrenheit temperature 1 Low accuracy Celsius temperature
 */
@property (nonatomic,assign) NSInteger precision;

/**
 msg 提示信息
 
 msg prompt message

 */
@property (nonatomic,copy) NSString *msg;

/**
 范围
 range = 0 表示温度范围为32.0℃-42.9℃（低精度）/32.00℃-42.99℃（高精度），
 range=1，表示温度范围为32.0℃-43.9℃（低精度）/32.00℃-43.99℃（高精度）
 range
 
 range = 0 means the temperature range is 32.0℃-42.9℃ (low precision)/32.00℃-42.99℃ (high precision),
 range=1, which means the temperature range is 32.0℃-43.9℃ (low precision)/32.00℃-43.99℃ (high precision)
 */
@property (nonatomic,assign) NSInteger range;

/**
解析之前字16进制符串(sdk内部调试时使用)
Parse the hexadecimal string of the previous word (used in internal debugging of the SDK)
 */
@property (nonatomic,copy) NSString *originalStr;


@end

NS_ASSUME_NONNULL_END
