#import "RNNOptions.h"

@interface DotIndicatorOptions : RNNOptions

@property(nonatomic, strong) Color *color;
@property(nonatomic, strong) Number *size;
@property(nonatomic, strong) RNNBool *visible;

- (bool)hasValue;

@end