//
//  JTHemoglobinModel.h
//  JTThermometer
//
//  Created by sky on 2021/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTHemoglobinModel : NSObject
/**
  单位 1：g/dL；2：mmol/L；3：g/L
 */
@property (nonatomic, assign) NSInteger unit;
/**
 浓度 
 Concentration
 */
@property (nonatomic, copy) NSString *density;
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
