#import "Interpolator.h"
#import "RNNOptions.h"

@interface TransitionDetailsOptions : RNNOptions

@property(nonatomic, strong) RNNDouble *from;
@property(nonatomic, strong) RNNDouble *to;
@property(nonatomic, strong) TimeInterval *duration;
@property(nonatomic, strong) TimeInterval *startDelay;
@property(nonatomic, strong) id<Interpolator> interpolator;

- (BOOL)hasAnimation;

@end
