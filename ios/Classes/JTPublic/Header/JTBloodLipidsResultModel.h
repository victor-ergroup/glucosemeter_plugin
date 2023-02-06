//
//  JTBloodLipidsResultModel.h
//  BluetoothDemo
//
//  Created by sky on 2021/12/12.
//

#import <Foundation/Foundation.h>
#import "JTBloodLipidsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JTBloodLipidsResultModel : NSObject

/**
 功能字 type
 2f 记忆同步 获取浓度数组
 09 请插入试纸
 0a 请滴血
 0b 测量中倒计时
 0c Er1-测试过程中试纸移动或者机器异常
 0d Er2-提前加样
 0e Er3-试纸条被使用过
 0f Er4-电池电量过低
 10 Er5-请查看说明书
 11 Er6-其他问题
 
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
@property (nonatomic,strong) NSArray<JTBloodLipidsModel*>*datas;

@end

NS_ASSUME_NONNULL_END
