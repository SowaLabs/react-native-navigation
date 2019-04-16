#import "Param.h"

@interface RNNDouble : Param

+ (instancetype)withValue:(double)value;

- (double)get;

- (double)getWithDefaultValue:(double)defaultValue;

@end
