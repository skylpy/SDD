//
//  JoinFilterCache.m
//  SDD
//  加盟筛选缓存
//  Created by Cola on 15/7/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinFilterCache.h"
#import "CategoryCell.h"

@implementation JoinFilterCache

/**
 *面积要求
 **/
+(void) AreaFilterCache:(NSMutableArray *)cache
{
    NSDictionary *param = @{};

    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/areaCategoryList.do" params:param success:^(id JSON) {
        
//                NSLog(@"Json \n %@",JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            for (NSDictionary *tempDic in dict) {
                
                CategoryCell *model = [[CategoryCell alloc] init];
                
                model.areaCategoryId = tempDic[@"areaCategoryId"];
                model.categoryName = tempDic[@"categoryName"];
                model.sort = tempDic[@"sort"];
                
                [cache addObject:model];
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

/**
 *投资金额
 **/
+(void) InvestmentFilterCache:(NSMutableArray *)cache
{
    NSDictionary *param = @{};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/investmentAmountCategoryList.do" params:param success:^(id JSON) {
        
//        NSLog(@"Json \n %@",JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            for (NSDictionary *tempDic in dict) {
                
                CategoryCell *model = [[CategoryCell alloc] init];
                
                model.areaCategoryId = tempDic[@"investmentAmountCategoryId"];
                model.categoryName = tempDic[@"categoryName"];
                model.sort = tempDic[@"sort"];
                
                [cache addObject:model];
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

/**
 *物业类型
 **/
//+(void) PropertyFilterCache:(NSMutableArray *)cache
//{
//    NSDictionary *param = @{};
//    
//    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/propertyTypeCategoryList.do" params:param success:^(id JSON) {
//        
//        //        NSLog(@"Json \n %@",JSON);
//        NSDictionary *dict = JSON[@"data"];
//        
//        if (![dict isEqual:[NSNull null]]) {
//            
//            for (NSDictionary *tempDic in dict) {
//                
//                CategoryCell *model = [[CategoryCell alloc] init];
//                
//                model.areaCategoryId = tempDic[@"propertyTypeCategoryId"];
//                model.categoryName = tempDic[@"categoryName"];
//                model.sort = tempDic[@"sort"];
//                
//                [cache addObject:model];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"错误 -- %@", error);
//    }];
//}

/**
 *品牌性质
 **/
+(void) CharacterFilterCache:(NSMutableArray *)cache
{
    NSDictionary *param = @{};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/characterCategoryList.do" params:param success:^(id JSON) {
        
        //        NSLog(@"Json \n %@",JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            for (NSDictionary *tempDic in dict) {
                
                CategoryCell *model = [[CategoryCell alloc] init];
                
                model.areaCategoryId = tempDic[@"characterCategoryId"];
                model.categoryName = tempDic[@"categoryName"];
                model.sort = tempDic[@"sort"];
                
                [cache addObject:model];
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];    
}

@end
