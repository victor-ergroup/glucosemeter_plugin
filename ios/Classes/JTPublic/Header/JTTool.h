//
//  JTTool.h
//  JTThermometer
//
//  Created by sky on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTTool : NSObject

/// 十六进制字符串转成二进制字符串
/// @param hex 进制字符串
+ (NSString *)getBinaryByHex:(NSString *)hex;

/// data转为16进制字符串
/// @param data data
+ (NSString *)convertDataToHexStr:(NSData *)data;
//16进制字符串转为data
+ (NSData *)convertHexStrToData:(NSString *)str;

// 十进制转十六进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal;
// 获取校验和的字节
+ (Byte)getCheckSum:(NSData *)byteStr;
///// @param string 16进制字符串
//+ (NSString *)convertDataToHexStr:(NSString *)string;
//二进制转十进制
+ (NSInteger)getDecimalByBinary:(NSString *)binary;
// 验证命令的校验和是否正确
+ (BOOL)verifyChecksumWithValueString:(NSString *)value;
//摄氏度转华氏度
+(double)getfahrenheitWithCelsius:(double)celsius;
+ (NSArray *)getBloodPressureTime;
@end

NS_ASSUME_NONNULL_END
