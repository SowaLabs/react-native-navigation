#import "RNNOptions.h"
#import "RNNComponentOptions.h"

@interface RNNBackgroundOptions : RNNOptions

@property (nonatomic, strong) Color* color;
@property (nonatomic, strong) RNNBool* translucent;
@property (nonatomic, strong) RNNBool* blur;
@property (nonatomic, strong) RNNBool* clipToBounds;
@property (nonatomic, strong) RNNComponentOptions* component;

@end
