#import "BoolParser.h"
#import "NullBool.h"

@implementation BoolParser

+ (RNNBool *)parse:(NSDictionary *)json key:(NSString *)key {
	return json[key] ? [[RNNBool alloc] initWithValue:json[key]] : [NullBool new];
}

@end
