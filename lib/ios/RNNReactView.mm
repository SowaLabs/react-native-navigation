#import "RNNReactView.h"
#import <React/RCTRootContentView.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTFabricSurface.h>
#endif

@implementation RNNReactView {
    BOOL _isAppeared;
}
#ifdef RCT_NEW_ARCH_ENABLED
- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties
                  eventEmitter:(RNNEventEmitter *)eventEmitter
               sizeMeasureMode:(RCTSurfaceSizeMeasureMode)sizeMeasureMode
           reactViewReadyBlock:(RNNReactViewReadyCompletionBlock)reactViewReadyBlock {
  RCTFabricSurface *surface = [[RCTFabricSurface alloc] initWithBridge:bridge moduleName:moduleName initialProperties:initialProperties];
  self = [super initWithSurface:surface sizeMeasureMode:sizeMeasureMode];
  [surface start];
#else
- (instancetype)initWithBridge:(RCTBridge *)bridge
                    moduleName:(NSString *)moduleName
             initialProperties:(NSDictionary *)initialProperties
                  eventEmitter:(RNNEventEmitter *)eventEmitter
           reactViewReadyBlock:(RNNReactViewReadyCompletionBlock)reactViewReadyBlock {
    self = [super initWithBridge:bridge moduleName:moduleName initialProperties:initialProperties];
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidAppear:)
                                                 name:RCTContentDidAppearNotification
                                               object:nil];
    _reactViewReadyBlock = reactViewReadyBlock;
    _eventEmitter = eventEmitter;

    return self;
}

- (void)contentDidAppear:(NSNotification *)notification {
    RNNReactView *appearedView = notification.object;
    if ([appearedView.appProperties[@"componentId"] isEqual:self.componentId]) {
        [self reactViewReady];
    }
}

- (void)reactViewReady {
    if (_reactViewReadyBlock) {
        _reactViewReadyBlock();
        _reactViewReadyBlock = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)componentWillAppear {
    if (!_isAppeared) {
        [_eventEmitter sendComponentWillAppear:self.componentId
                                 componentName:self.moduleName
                                 componentType:self.componentType];
    }
}

- (void)componentDidAppear {
    if (!_isAppeared) {
        [_eventEmitter sendComponentDidAppear:self.componentId
                                componentName:self.moduleName
                                componentType:self.componentType];
    }

    _isAppeared = YES;
}

- (void)componentDidDisappear {
    if (_isAppeared) {
        [_eventEmitter sendComponentDidDisappear:self.componentId
                                   componentName:self.moduleName
                                   componentType:self.componentType];
    }

    _isAppeared = NO;
}

- (void)invalidate {
    [((RCTRootContentView *)self.contentView) invalidate];
}

- (NSString *)componentId {
    return self.appProperties[@"componentId"];
}

- (NSString *)componentType {
    @throw [NSException exceptionWithName:@"componentType not implemented"
                                   reason:@"Should always subclass RNNReactView"
                                 userInfo:nil];
}

@end
