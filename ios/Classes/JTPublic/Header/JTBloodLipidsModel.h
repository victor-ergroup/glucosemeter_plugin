//
//  JTBloodLipidsModel.h
//  BluetoothDemo
//
//  Created by sky on 2021/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBloodLipidsModel : NSObject

/**
  单位 1：mg/dL；2：mmol/L；
 */
@property (nonatomic, assign) NSInteger unit;
/**
  样本类型 0:P血，1：b血
 */
@property (nonatomic, assign) NSInteger type;
/**
 TC
 */
@property (nonatomic, copy) NSString *TC;
/**
 TG
 */
@property (nonatomic, copy) NSString *TG;
/**
 HDL
 */
@property (nonatomic, copy) NSString *HDL;

/**
 时间
 time
 */
@property (nonatomic, copy) NSString *time;
/**
 ID
 */
@property (nonatomic, assign) NSInteger ID;
/**
 浓度单位字符串
 */
@property (nonatomic, copy) NSString *unitName;

@end

NS_ASSUME_NONNULL_END
