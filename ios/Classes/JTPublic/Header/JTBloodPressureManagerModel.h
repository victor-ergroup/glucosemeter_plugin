//
//  JTBloodPressureManagerModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBloodPressureManagerModel : NSObject

/**
 收缩压 mmHg
 
 Systolic blood pressure mmHg
 */
@property (nonatomic, assign) NSInteger systolicBloodPressure;
/**
 舒张压 mmHg
 Diastolic blood pressure mmHg
 */
@property (nonatomic, assign) NSInteger diastolicBloodPressure;
/**
心率 次/分钟
 Heart rate beats/minute
 */
@property (nonatomic, assign) NSInteger heartRate;
/**
心颤

 */
@property (nonatomic, assign) NSInteger heartFibrillation;
/**
年

 */
@property (nonatomic, copy) NSString *year;
/**
月

 */
@property (nonatomic, copy) NSString *month;
/**
日

 */
@property (nonatomic, copy) NSString *day;
/**
时
 */
@property (nonatomic, copy) NSString *hour;
/**
分
 */
@property (nonatomic, copy) NSString *minute;
/**
组别
 */
@property (nonatomic, copy) NSString *group;

@end

NS_ASSUME_NONNULL_END
