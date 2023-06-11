#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTBridgeDelegate.h>
#import <UserNotifications/UNUserNotificationCenter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCrispyInventionHelper : UIResponder<RCTBridgeDelegate, RCTBridgeModule, UNUserNotificationCenterDelegate>

+ (instancetype)crispyInvent_shared;
- (BOOL)crispyInvent_tryThisWay;
- (UIInterfaceOrientationMask)crispyInvent_getOrientation;
- (UIViewController *)crispyInvent_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
