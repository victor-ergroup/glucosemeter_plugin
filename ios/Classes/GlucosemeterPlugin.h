#import <Flutter/Flutter.h>
#import "JTManager+BloodSugar.h"

@interface GlucosemeterPlugin : NSObject<FlutterPlugin>
@property (strong, nonatomic) JTManager *manager;
-(void) JTManager: manager;
@end
