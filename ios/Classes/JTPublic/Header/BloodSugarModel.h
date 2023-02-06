//
//  BloodSugarModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BloodSugarModel : NSObject

/**
 浓度 单位 mmol/L
 Concentration unit mmol/L
 */
@property (nonatomic, copy) NSString *density;
/**
 时间戳
 timestamp
 */
@property (nonatomic, copy) NSString *timestamp;



@end

NS_ASSUME_NONNULL_END
