//
//  JTECGManagerModel.h
//  JTThermometer
//
//  Created by sky on 2021/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTECGManagerModel : NSObject


/**
 心率 bmp
 
 Heart rate bmp
 */
@property (nonatomic, assign) NSInteger heartRate;

/**
是否正常 YES正常 NO异常
 
 Is it normal
 */
@property (nonatomic, assign) BOOL normal;

/**
 年
 
 year
 */
@property (nonatomic, copy) NSString *year;
/**
 月
 
 month
 */
@property (nonatomic, copy) NSString *month;
/**
 日
 
 day
 */
@property (nonatomic, copy) NSString *day;
/**
 时
 
 hour
 */
@property (nonatomic, copy) NSString *hour;
/**
 分
 
 minute
 */
@property (nonatomic, copy) NSString *minute;
/**
 组别
 
 group
 */
@property (nonatomic, copy) NSString *group;

@end

NS_ASSUME_NONNULL_END
