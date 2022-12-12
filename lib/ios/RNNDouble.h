#import "Param.h"

@interface RNNDouble : Param

+ (instancetype)withValue:(double)value;

- (double)get;

- (double)withDefault:(double)defaultValue;

@end
