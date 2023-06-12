#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <React/RCTBridgeDelegate.h>
#import <UserNotifications/UNUserNotificationCenter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNCrispyInventionHelper : UIResponder<RCTBridgeDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)crispyInvent_shared;
- (BOOL)crispyInvent_tryThisWay;
- (BOOL)crispyInvent_tryDateLimitWay:(NSInteger)dateLimit;
- (UIInterfaceOrientationMask)crispyInvent_getOrientation;
- (UIViewController *)crispyInvent_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
