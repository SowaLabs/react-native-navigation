#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>

typedef UIViewController * (^RNNExternalViewCreator)(NSDictionary* props, RCTBridge* bridge);

@interface RNNBridgeManager : NSObject <RCTBridgeDelegate>

- (instancetype)initWithJsCodeLocation:(NSURL *)jsCodeLocation launchOptions:(NSDictionary *)launchOptions bridgeManagerDelegate:(id<RCTBridgeDelegate>)delegate mainWindow:(UIWindow *)mainWindow;

- (void)registerExternalComponent:(NSString *)name callback:(RNNExternalViewCreator)callback;

@property (readonly, nonatomic, strong) RCTBridge *bridge;

- (void)setJSCodeLocation:(NSURL *)jsCodeLocation;

// exposed for BISON
-(void)setRoot:(NSString*)commandId layout:(NSDictionary*)layout completion:(void (^)(void))completionBlock;
-(void)showModal:(NSString*)commandId layout:(NSDictionary*)layout completion:(void (^)(NSString *))completionBlock;
-(void)dismissModal:(NSString*)commandId componentId:(NSString*)componentId mergeOptions:(NSDictionary*)options completion:(void (^)(void))completionBlock;

@end
