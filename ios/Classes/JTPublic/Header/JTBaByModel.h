//
//  JTBaByModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBaByModel : NSObject

/**
 功能字
 04  返回温度
 07 低电压报错
 08 Err-传感器短路、断路等
 10 程序编码和版本信息
 81 实时监控模式
 82 非实时监控模式
 83 防踢被提醒
 85 On/Off键锁死
 86 On/Off键解锁
 89 获取 测量模式和锁死状态
 
 Function word
   04 Return temperature
   07 Low voltage error
   08 Err-Sensor short circuit, open circuit, etc.
   10 Program code and version information
   81 Real-time monitoring mode
   82 Non-real-time monitoring mode
   83 Anti-kick is reminded
   85 On/Off key is locked
   86 On/Off key to unlock
   89 Get measurement mode and lock state
 */
@property (nonatomic,copy) NSString *type;
/**
 msg 提示信息
 msg prompt message
 */
@property (nonatomic,copy) NSString *msg;

/**
  温度
 temperature
 */
@property (nonatomic,copy) NSString *temperature;
/**
 测量模式
 type 89 有值
 01 实时监控模式
 02 非实时监控模式
 03 防踢被提醒
 
 Measurement mode
   type 89 has value
   01 Real-time monitoring mode
   02 Non-real-time monitoring mode
   03 Anti-kick is reminded
 */
@property (nonatomic,copy) NSString *mode;
/**
 是否为锁定模式
 type 89 有值
 
 Whether it is locked mode
   type 89 has value
 */
@property (nonatomic,assign) BOOL clock;

@end

NS_ASSUME_NONNULL_END
