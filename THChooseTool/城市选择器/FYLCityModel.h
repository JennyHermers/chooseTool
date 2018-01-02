//
//  FYLCityModel.h


#import <Foundation/Foundation.h>

@class FYLProvince,FYLCity,FYLTown;

@interface FYLProvince : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *city;

@end

@interface FYLCity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *town;

@end


@interface FYLTown : NSObject

@property (nonatomic, copy) NSString *name;

@end
