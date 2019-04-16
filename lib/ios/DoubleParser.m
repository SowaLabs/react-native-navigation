#import "DoubleParser.h"
#import "NullDouble.h"

@implementation DoubleParser

+ (RNNDouble *)parse:(NSDictionary *)json key:(NSString *)key {
	return json[key] ? [[RNNDouble alloc] initWithValue:json[key]] : [NullDouble new];
}

@end
