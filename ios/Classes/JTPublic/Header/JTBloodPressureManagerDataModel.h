//
//  JTBloodPressureManagerDataModel.h
//  JTThermometer
//
//  Created by sky on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBloodPressureManagerDataModel : NSObject
/**
 type 功能字
 type function word
 */
@property (nonatomic,copy) NSString *type;

@property (nonatomic, copy) NSString *value;

@end

NS_ASSUME_NONNULL_END
