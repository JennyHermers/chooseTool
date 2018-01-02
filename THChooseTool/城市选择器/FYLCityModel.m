//
//  FYLCityModel.m


#import "FYLCityModel.h"


@implementation FYLProvince

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"v",
             @"city" : @"n"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city" : [FYLCity class]};
}

@end

@implementation FYLCity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"v",
             @"town" : @"n"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"town" : [FYLTown class]};
}

@end

@implementation FYLTown

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"v"};
}

@end
