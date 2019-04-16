#import <Foundation/Foundation.h>
#import "RNNDictionary.h"

@interface DictionaryParser : NSObject

+ (RNNDictionary *)parse:(NSDictionary *)json key:(NSString *)key;

@end
