//
//  Header.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#ifndef ShopMoreAndMore_Header_h
#define ShopMoreAndMore_Header_h

#define SDD_AFNetRequest NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,path];\
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];\
manager.responseSerializer = [AFJSONResponseSerializer serializer];\
manager.requestSerializer = [AFJSONRequestSerializer serializer];\
[manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];\
manager.requestSerializer.timeoutInterval = 15.f;\
[manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
#define PREVIEW SDD_Preview *preview = [[SDD_Preview alloc] init];\
[self.navigationController pushViewController:preview animated:YES];
#define CELLSELECTSTYLE cell.selectionStyle = UITableViewCellSelectionStyleNone;

#import "PersentViewController.h"
#import "SDD_IssueMainViewController.h"
#import "SDD_DeveloperList.h"
#import "SDD_ItemDetail.h"
#import "SDD_UpLoadData.h"
#import "SDD_BasicInformation.h"
#import "SDD_Preview.h"
#import "SDD_MoreInfomation.h"
#import "SDD_IssueResult.h"
#import "SDD_MyPersonCenter.h"
#import "CertifyFirstStep.h"
#import "CertifySecondStep.h"
#import "SDD_MyIssueViewController.h"
#import "SDD_IssueMainViewController.h"

#import "SDD_NextButtonCell.h"
#import "SDD_BasicCell.h"
#import "SDD_CooperationCell.h"
#import "SDD_DetailCell.h"
#import "SDD_DetailValueCell.h"
#import "SDD_TextViewCell.h"
#import "SDD_DoubleImageViewCell.h"
#import "SDD_SaveIssueCell.h"
#import "SDD_previewBasicCell.h"
#import "SDD_PreviewDetailCell.h"
#import "SDD_PreviewOptionalCell.h"
#import "SDD_MoreInfoCell.h"
#import "SDD_MoreInfoLvCell.h"
#import "SDD_MyPersonThirdButtonCell.h"
#import "SDD_MyPersonList.h"
#import "SDD_CertifyCell.h"
#import "SDD_MyIssueCell.h"
#import "SDD_MyIssueStatusCell.h"
#import "DateAlterView.h"

#import "AFNetworking.h"
#import "HttpRequest.h"
#import "SDDColor.h"
#import "LPlaceholderTextView.h"



#endif
