#import "RNNDouble.h"

@interface TimeInterval : RNNDouble

- (NSTimeInterval)get;

- (NSTimeInterval)getWithDefaultValue:(double)defaultValue;

@end
