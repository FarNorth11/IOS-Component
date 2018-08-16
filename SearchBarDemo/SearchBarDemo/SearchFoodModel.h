//
//  SearchFoodModel.h
//  wisdom_school_ios
//
//  Created by Ben on 2018/5/22.
//  Copyright © 2018年 het. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFoodModel : NSObject
@property(nonatomic,copy)NSNumber *ingredientId;//      食材id
@property(nonatomic,copy)NSString *ingredientName;//    食材名称
@property(nonatomic,copy)NSString *ingredientAlias;//    食材别名

@property(nonatomic,strong)NSString *categoryName;//分类名称
@property(nonatomic,copy)NSString *firstCharactor;//    首字母
@property(nonatomic,copy)NSString *allCharactor;//    全拼

@end
