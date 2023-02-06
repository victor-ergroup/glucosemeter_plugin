//
//  JTHemoglobinResultModel.h
//  JTThermometer
//
//  Created by sky on 2021/7/7.
//

#import <Foundation/Foundation.h>
#import "JTHemoglobinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JTHemoglobinResultModel : NSObject

/**
 功能字 type
 2f 记忆同步 获取浓度数组，第一组为最新数据
 09 请插入试纸
 0a 请滴血
 0b 测量中倒计时
 0c Er1-测试过程中试纸移动或者机器异常
 0d Er2-提前加样
 0e Er3-试纸条被使用过
 0f Er4-电池电量过低
 10 Er5-请查看说明书
 11 Er6-其他问题
 
 Function word type
   2f Memory synchronization Get concentration array, the first group is the latest data
   09 Please insert test paper
   0a please drop blood
   0b Countdown during measurement
   0c Er1-Reserved 400mV self-test after startup
   0d Er2-The test paper is used or damp
   0e Er3-Blood is too early
   0f Er4-Move the test paper during measurement
   10 Er5-test paper self-check problem
   11 Er6-The room temperature is too high or too low
 */
@property (nonatomic,copy) NSString *type;
/**
 msg 提示信息
 */
@property (nonatomic,copy) NSString *msg;
/**
 msg 倒计时时间 秒
 msg prompt message
 */
@property (nonatomic,assign) NSInteger time;
/**
 血红蛋白浓度数组
 Blood glucose concentration array
 */
@property (nonatomic,strong) NSArray<JTHemoglobinModel*>*datas;


@end

NS_ASSUME_NONNULL_END
