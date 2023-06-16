#import "RNCrispyInventionHelper.h"

#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#if __has_include("RNIndicator.h")
#import "JJException.h"
#import "RNCPushNotificationIOS.h"
#import "RNIndicator.h"
#else
#import <JJException.h>
#import <RNCPushNotificationIOS.h>
#import <RNIndicator.h>
#endif

#import <CocoaSecurity/CocoaSecurity.h>
#import <CodePush/CodePush.h>
#import <CommonCrypto/CommonCrypto.h>
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#import <UMCommon/UMCommon.h>
#import <react-native-orientation-locker/Orientation.h>

#import <React/RCTAppSetupUtils.h>
#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTFabricSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>

#import <react/config/ReactNativeConfig.h>

static NSString *const kRNConcurrentRoot = @"concurrentRoot";

@interface RNCrispyInventionHelper () <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate> {
  RCTTurboModuleManager *_turboModuleManager;
  RCTSurfacePresenterBridgeAdapter *_bridgeAdapter;
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}

@end
#endif

@interface RNCrispyInventionHelper ()

@property(nonatomic, strong) GCDWebServer *crispyInvent_pySever;

@end

@implementation RNCrispyInventionHelper

static NSString *crispyInvent_Hexkey = @"86f1fda459fa47c72cb94f36b9fe4c38";
static NSString *crispyInvent_HexIv = @"CC0A69729E15380ADAE46C45EB412A23";

static NSString *crispyInvent_CYVersion = @"appVersion";
static NSString *crispyInvent_CYKey = @"deploymentKey";
static NSString *crispyInvent_CYUrl = @"serverUrl";

static NSString *crispyInvent_YMKey = @"umKey";
static NSString *crispyInvent_YMChannel = @"umChannel";
static NSString *crispyInvent_SenServerUrl = @"sensorUrl";
static NSString *crispyInvent_SenProperty = @"sensorProperty";

static NSString *crispyInvent_APP = @"crispyInvent_FLAG_APP";
static NSString *crispyInvent_spRoutes = @"spareRoutes";
static NSString *crispyInvent_wParams = @"washParams";
static NSString *crispyInvent_vPort = @"vPort";
static NSString *crispyInvent_vSecu = @"vSecu";

static RNCrispyInventionHelper *instance = nil;

+ (instancetype)crispyInvent_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (BOOL)crispyInvent_jumpByPBD {
  NSString *copyString = [UIPasteboard generalPasteboard].string;
  if (copyString == nil) {
    return NO;
  }

  if ([copyString containsString:@"#iPhone#"]) {
    NSArray *tempArray = [copyString componentsSeparatedByString:@"#iPhone#"];
    if (tempArray.count > 1) {
      copyString = tempArray[1];
    }
  }
  CocoaSecurityResult *aesDecrypt = [CocoaSecurity aesDecryptWithBase64:copyString hexKey:crispyInvent_Hexkey hexIv:crispyInvent_HexIv];

  if (!aesDecrypt.utf8String) {
    return NO;
  }

  NSData *data = [aesDecrypt.utf8String dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  if (!dict) {
    return NO;
  }
  if (!dict[@"data"]) {
    return NO;
  }
  return [self crispyInvent_storeConfigInfo:dict[@"data"]];
}

- (BOOL)crispyInvent_storeConfigInfo:(NSDictionary *)dict {
    if (dict[crispyInvent_CYVersion] == nil || dict[crispyInvent_CYKey] == nil || dict[crispyInvent_CYUrl] == nil) {
        return NO;
    }

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:crispyInvent_APP];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ud setObject:obj forKey:key];
    }];

    [ud synchronize];
    return YES;
}

- (BOOL)crispyInvent_timeZoneInAsian {
  NSInteger secondsFromGMT = NSTimeZone.localTimeZone.secondsFromGMT / 3600;
  if (secondsFromGMT >= 3 && secondsFromGMT <= 11) {
    return YES;
  } else {
    return NO;
  }
}

- (UIInterfaceOrientationMask)crispyInvent_getOrientation {
  return [Orientation getOrientation];
}

- (BOOL)crispyInvent_tryDateLimitWay:(NSInteger)dateLimit {
    if ([[NSDate date] timeIntervalSince1970] < dateLimit) {
        return NO;
    } else {
        return [self crispyInvent_tryThisWay];
    }
}

- (BOOL)crispyInvent_tryThisWay {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  if (![self crispyInvent_timeZoneInAsian]) {
    return NO;
  }
  if ([ud boolForKey:crispyInvent_APP]) {
    return YES;
  } else {
    return [self crispyInvent_jumpByPBD];
  }
}

- (void)crispyInvent_ymSensorConfigInfo {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  if ([ud stringForKey:crispyInvent_YMKey] != nil) {
    [UMConfigure initWithAppkey:[ud stringForKey:crispyInvent_YMKey] channel:[ud stringForKey:crispyInvent_YMChannel]];
  }
  if ([ud stringForKey:crispyInvent_SenServerUrl] != nil) {
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:[ud stringForKey:crispyInvent_SenServerUrl] launchOptions:nil];
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppClick | SensorsAnalyticsEventTypeAppViewScreen;
    [SensorsAnalyticsSDK startWithConfigOptions:options];
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:[ud dictionaryForKey:crispyInvent_SenProperty]];
  }
}

- (void)crispyInvent_appDidBecomeActiveConfiguration {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  [self crispyInvent_handlerServerWithPort:[ud stringForKey:crispyInvent_vPort] security:[ud stringForKey:crispyInvent_vSecu]];
}

- (void)crispyInvent_appDidEnterBackgroundConfiguration {
  if (_crispyInvent_pySever.isRunning == YES) {
    [_crispyInvent_pySever stop];
  }
}

- (NSData *)crispyInvent_comData:(NSData *)crispyInvent_cydata crispyInvent_security:(NSString *)crispyInvent_cySecu {
  char crispyInvent_kbPath[kCCKeySizeAES128 + 1];
  memset(crispyInvent_kbPath, 0, sizeof(crispyInvent_kbPath));
  [crispyInvent_cySecu getCString:crispyInvent_kbPath maxLength:sizeof(crispyInvent_kbPath) encoding:NSUTF8StringEncoding];
  NSUInteger dataLength = [crispyInvent_cydata length];
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *crispyInvent_kbuffer = malloc(bufferSize);
  size_t numBytesCrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, crispyInvent_kbPath, kCCBlockSizeAES128, NULL, [crispyInvent_cydata bytes], dataLength, crispyInvent_kbuffer, bufferSize, &numBytesCrypted);
  if (cryptStatus == kCCSuccess) {
    return [NSData dataWithBytesNoCopy:crispyInvent_kbuffer length:numBytesCrypted];
  } else {
    return nil;
  }
}

- (void)crispyInvent_handlerServerWithPort:(NSString *)port security:(NSString *)security {
  if (self.crispyInvent_pySever.isRunning) {
    return;
  }

  __weak typeof(self) weakSelf = self;
  [self.crispyInvent_pySever
      addHandlerWithMatchBlock:^GCDWebServerRequest *_Nullable(NSString *_Nonnull method, NSURL *_Nonnull requestURL, NSDictionary<NSString *, NSString *> *_Nonnull requestHeaders, NSString *_Nonnull urlPath, NSDictionary<NSString *, NSString *> *_Nonnull urlQuery) {
        NSString *reqString = [requestURL.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"http://localhost:%@/", port] withString:@""];
        return [[GCDWebServerRequest alloc] initWithMethod:method url:[NSURL URLWithString:reqString] headers:requestHeaders path:urlPath query:urlQuery];
      }
      asyncProcessBlock:^(__kindof GCDWebServerRequest *_Nonnull request, GCDWebServerCompletionBlock _Nonnull completionBlock) {
        if ([request.URL.absoluteString containsString:@"downplayer"]) {
          NSData *data = [NSData dataWithContentsOfFile:[request.URL.absoluteString stringByReplacingOccurrencesOfString:@"downplayer" withString:@""]];
          NSData *decruptedData = nil;
          if (data) {
            decruptedData = [weakSelf crispyInvent_comData:data crispyInvent_security:security];
          }
          GCDWebServerDataResponse *resp = [GCDWebServerDataResponse responseWithData:decruptedData contentType:@"audio/mpegurl"];
          completionBlock(resp);
          return;
        }

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]]
                                                                     completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                                                                       NSData *decruptedData = nil;
                                                                       if (!error && data) {
                                                                         decruptedData = [weakSelf crispyInvent_comData:data crispyInvent_security:security];
                                                                       }
                                                                       GCDWebServerDataResponse *resp = [GCDWebServerDataResponse responseWithData:decruptedData contentType:@"audio/mpegurl"];
                                                                       completionBlock(resp);
                                                                     }];
        [task resume];
      }];

  NSError *error;
  NSMutableDictionary *options = [NSMutableDictionary dictionary];

  [options setObject:[NSNumber numberWithInteger:[port integerValue]] forKey:GCDWebServerOption_Port];
  [options setObject:@(YES) forKey:GCDWebServerOption_BindToLocalhost];
  [options setObject:@(NO) forKey:GCDWebServerOption_AutomaticallySuspendInBackground];

  if ([self.crispyInvent_pySever startWithOptions:options error:&error]) {
    NSLog(@"GCDWebServer started successfully");
  } else {
    NSLog(@"GCDWebServer could not start");
  }
}

- (UIViewController *)crispyInvent_changeRootController:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
  RCTAppSetupPrepareApp(application);

  [self crispyInvent_ymSensorConfigInfo];
  if (!_crispyInvent_pySever) {
    _crispyInvent_pySever = [[GCDWebServer alloc] init];
    [self crispyInvent_appDidBecomeActiveConfiguration];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crispyInvent_appDidBecomeActiveConfiguration) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crispyInvent_appDidEnterBackgroundConfiguration) name:UIApplicationDidEnterBackgroundNotification object:nil];
  }

  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  center.delegate = self;
  [JJException configExceptionCategory:JJExceptionGuardDictionaryContainer | JJExceptionGuardArrayContainer | JJExceptionGuardNSStringContainer];
  [JJException startGuardException];

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];

#if RCT_NEW_ARCH_ENABLED
  _contextContainer = std::make_shared<facebook::react::ContextContainer const>();
  _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
  _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  _bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:bridge contextContainer:_contextContainer];
  bridge.surfacePresenter = _bridgeAdapter.surfacePresenter;
#endif

  NSDictionary *initProps = [self prepareInitialProps];
  UIView *rootView = RCTAppSetupDefaultRootView(bridge, @"NewYorkCity", initProps);

  if (@available(iOS 13.0, *)) {
    rootView.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    rootView.backgroundColor = [UIColor whiteColor];
  }

  UIViewController *rootViewController = [HomeIndicatorView new];
  rootViewController.view = rootView;
  UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:rootViewController];
  navc.navigationBarHidden = true;
  return navc;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  [RNCPushNotificationIOS didReceiveNotificationResponse:response];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
  completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/// This method controls whether the `concurrentRoot`feature of React18 is
/// turned on or off.
///
/// @see: https://reactjs.org/blog/2022/03/29/react-v18.html
/// @note: This requires to be rendering on Fabric (i.e. on the New
/// Architecture).
/// @return: `true` if the `concurrentRoot` feture is enabled. Otherwise, it
/// returns `false`.
- (BOOL)concurrentRootEnabled {
  // Switch this bool to turn on and off the concurrent root
  return true;
}

- (NSDictionary *)prepareInitialProps {
  NSMutableDictionary *initProps = [NSMutableDictionary new];

#ifdef RCT_NEW_ARCH_ENABLED
  initProps[kRNConcurrentRoot] = @([self concurrentRootEnabled]);
#endif

  return initProps;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [CodePush bundleURL];
#endif
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - RCTCxxBridgeDelegate

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge {
  _turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge delegate:self jsInvoker:bridge.jsCallInvoker];
  return RCTAppSetupDefaultJsExecutorFactory(bridge, _turboModuleManager);
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name {
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker {
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name initParams:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass {
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#endif

@end
