//
//  JTManager.h
//  BluetoothDemo
//
//  Created by sky on 2021/10/30.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "MTTempModel.h"
#import "DETTempModel.h"
#import "JTSPOModel.h"
#import "OvulationModel.h"
#import "JTBaByModel.h"
#import "BloodSugarResultModel.h"
#import "JTHemoglobinResultModel.h"
#import "JTECGManagerModel.h"
#import "JTBloodPressureManagerModel.h"
#import "JTBloodPressureManagerDataModel.h"
#import "JTECGManagerRealModel.h"
#import "JTBloodLipidsResultModel.h"
#import "JTECGManagerMemoryModel.h"

#define WS(weakSelf) __unsafe_unretained __typeof(&*self)weakSelf = self;
NS_ASSUME_NONNULL_BEGIN

@protocol JTManagerDelegate <NSObject>
/**
设备状态改变的block |  when CentralManager state changed
*/
- (void)onCentralManagerDidUpdateState:(CBManagerState)state;
///  找到Peripherals的委托 | Find Peripherals' commission
/// @param central 中心设备 | Central equipment
/// @param peripheral 外围设备  | peripheral equipment
/// @param advertisementData 广告 | advertising
/// @param RSSI 信号强度  | Signal strength
- (void)jt_discoverToPeripherals:(CBCentralManager *_Nullable)central peripheral:(CBPeripheral *_Nullable)peripheral advertisementData:(NSDictionary *_Nullable)advertisementData RSSI:(NSNumber *_Nullable)RSSI;

/// 断开连接 | Disconnect
/// @param peripheral 被断开的外围设备 | Disconnected peripheral device
- (void)jt_disconnectCBPeripheral:(CBPeripheral *_Nonnull)peripheral;

/// 连接成功 | connection succeeded
/// @param peripheral 连接成功的外围设备 | Successfully connected peripherals
- (void)jt_connectSuccessCBPeripheral:(CBPeripheral *_Nonnull)peripheral;
//连接失败
- (void)jt_connectFailCBCentralManager:(CBCentralManager *)central CBPeripheral:(CBPeripheral *)peripheral NSError:(NSError *)error;

@end
/**
 温度计
 */
@protocol JTTempDelegate <NSObject>

/**
 返回温度MT温度计 | Return temperature MT thermometer
 */
- (void)jt_receivedDMTTemp:(MTTempModel*_Nullable)tempModel;

/// 返回温度DET-温度计 | Return temperature DET-thermometer
/// @param resultArr 温度数组  | Temperature array
- (void)jt_receivedDETTemp:(NSArray<DETTempModel*>*)resultArr;



@end

/**
 血氧
 */
@protocol JTSPODelegate <NSObject>

/**
 返回血氧数据 | Return blood oxygen data
 */
- (void)jt_receivedSopModel:(JTSPOModel*_Nullable)resultModel;



@end

/**
 排卵助手
 */
@protocol JTOvulationDelegate <NSObject>
/**
 返回排卵助手温度 | Return to ovulation assistant temperature
 */
- (void)jt_receivedOvulation:(OvulationModel*_Nullable)resultModel;

@end

/**
 宝宝看护
 */
@protocol JTBabyDelegate <NSObject>
/**
 返回解析后数据 | Return the parsed data
 */
- (void)jt_receivedBaByData:(JTBaByModel*_Nullable)resultModel;

@end

/**
 血糖
 */
@protocol JTBloodSugarDelegate <NSObject>

/// 返回血糖数据 | Return blood glucose data
/// @param resultModel 模型 | model
- (void)jt_receivedDensity:(BloodSugarResultModel*)resultModel;

@end

/**
 血红蛋白
 */
@protocol JTHemoglobinDelegate <NSObject>

/// 返回血红蛋白数据 | Return blood glucose data
/// @param resultModel 模型 | model
- (void)jt_receivedDensity:(JTHemoglobinResultModel*)resultModel;

@end
/**
 血脂
 */
@protocol JTBloodLipidsDelegate <NSObject>

/// 返回血脂数据 
/// @param resultModel 模型 | model
- (void)jt_receivedDensity:(JTBloodLipidsResultModel*)resultModel;

@end
/**
 心电
 */
@protocol JTECGManagerDelegate <NSObject>

//开始测量
-(void)jt_startMeasuring;

//实时数据 | Get a single measurement result
-(void)jt_receivedRealTimeHeartRate:(JTECGManagerRealModel*)model;

//获取测量结果 | Get a single measurement result
-(void)jt_receivedHeartRate:(JTECGManagerModel*)model;
//下载记忆
-(void)jt_receivedMemoryData:(NSArray<JTECGManagerMemoryModel*>*)arr;

@end

/**
 血压
 */
@protocol JTBloodPressureDelegate <NSObject>

//获取单次测量结果 | Get a single measurement result
-(void)jt_receivedPressure:(JTBloodPressureManagerModel*)model;

//获取实时测量结果 | Obtain real-time measurement results
-(void)jt_receivedRealTimeData:(JTBloodPressureManagerDataModel*)model;


@end


@interface JTManager : NSObject

+ (instancetype)shareInstance;
/**
 蓝牙管理类
 */
@property (nonatomic,strong) BabyBluetooth *bluetoothManager;

/**
 连接设备型号 | Connected device model
 */
@property (nonatomic,copy) NSString *name;

@property (nonatomic, copy) NSString *earString; // 记录耳温数据

@property (nonatomic, copy) NSString *dataString; 

@property (nonatomic, strong) CBPeripheral *connectedPeripheral;

@property (nonatomic, strong) CBCharacteristic *sendCharacteristic;
/**
 是否连接设备
 */
@property (nonatomic, assign) BOOL isConnected;
/**
 开始扫描设备
 */
- (void)startScan;
/**
 连接外围设备
 */
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
/**
 断开所有连接的外部设备
 */
- (void)allDisconnect;
/**
  取消扫描
 */
- (void)cancelScan;

/**
  自动连接
 */
- (void)autoConnect;

@property (nonatomic, weak) id<JTManagerDelegate> delegate;

@property (nonatomic, weak) id<JTTempDelegate> temp_delegate;

@property (nonatomic, weak) id<JTSPODelegate> spo_delegate;

@property (nonatomic, weak) id<JTOvulationDelegate> ovu_delegate;

@property (nonatomic, weak) id<JTBabyDelegate> baby_delegate;

@property (nonatomic, weak) id<JTBloodSugarDelegate> bloodSugar_delegate;

@property (nonatomic, weak) id<JTHemoglobinDelegate> hemoglobin_delegate;

@property (nonatomic, weak) id<JTBloodLipidsDelegate> bloodLipids_delegate;

@property (nonatomic, weak) id<JTECGManagerDelegate> ecg_delegate;

@property (nonatomic, weak) id<JTBloodPressureDelegate> bp_delegate;

@end

NS_ASSUME_NONNULL_END
