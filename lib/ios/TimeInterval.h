#import "RNNDouble.h"

@interface TimeInterval : RNNDouble

- (NSTimeInterval)get;

- (NSTimeInterval)withDefault:(double)defaultValue;

@end
