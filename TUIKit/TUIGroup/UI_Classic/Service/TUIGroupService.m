
#import "TUIGroupService.h"
#import "TUIGroupRequestViewController.h"
#import "TUIGroupInfoController.h"
#import "TUISelectGroupMemberViewController.h"
#import "TUIDefine.h"
#import "NSDictionary+TUISafe.h"
#import "TUIThemeManager.h"
#import "TUIGlobalization.h"

@implementation TUIGroupService

static NSString *g_serviceName = nil;

+ (void)load {
    [TUICore registerService:TUICore_TUIGroupService object:[TUIGroupService shareInstance]];
    TUIRegisterThemeResourcePath(TUIGroupThemePath, TUIThemeModuleGroup);
}

+ (TUIGroupService *)shareInstance {
    static dispatch_once_t onceToken;
    static TUIGroupService * g_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        g_sharedInstance = [[TUIGroupService alloc] init];
    });
    return g_sharedInstance;
}

- (UIViewController *)createGroupRequestViewController:(V2TIMGroupInfo *)groupInfo
{
    TUIGroupRequestViewController *vc = [[TUIGroupRequestViewController alloc] init];
    vc.groupInfo = groupInfo;
    return vc;
}

- (UIViewController *)createGroupInfoController:(NSString *)groupID
{
    TUIGroupInfoController *vc = [[TUIGroupInfoController alloc] init];
    vc.groupId = groupID;
    return vc;
}

- (UIViewController *)createSelectGroupMemberViewController:(NSString *)groupID
                                                                         name:(NSString *)name
                                                                optionalStyle:(TUISelectMemberOptionalStyle)optionalStyle {
    return [self createSelectGroupMemberViewController:groupID
                                                  name:name
                                         optionalStyle:optionalStyle
                                    selectedUserIDList:@[]];
}

- (UIViewController *)createSelectGroupMemberViewController:(NSString *)groupID
                                                       name:(NSString *)name
                                              optionalStyle:(TUISelectMemberOptionalStyle)optionalStyle
                                         selectedUserIDList:(NSArray *)userIDList {
    return [self createSelectGroupMemberViewController:groupID
                                                  name:name
                                         optionalStyle:optionalStyle
                                    selectedUserIDList:@[]
                                              userData:@""];
}

- (UIViewController *)createSelectGroupMemberViewController:(NSString *)groupID
                                                       name:(NSString *)name
                                              optionalStyle:(TUISelectMemberOptionalStyle)optionalStyle
                                         selectedUserIDList:(NSArray *)userIDList
                                                   userData:(NSString *)userData {
    TUISelectGroupMemberViewController *vc = [[TUISelectGroupMemberViewController alloc] init];
    vc.groupId = groupID;
    vc.name = name;
    vc.optionalStyle = optionalStyle;
    vc.selectedUserIDList = userIDList;
    vc.userData = userData;
    return vc;
}

- (void)createGroup:(NSString *)groupType
       createOption:(V2TIMGroupAddOpt)createOption
           contacts:(NSArray<TUICommonContactSelectCellData *> *)contacts
         completion:(void (^)(BOOL success, NSString *groupID, NSString *groupName))completion {
    NSString *loginUser = [[V2TIMManager sharedInstance] getLoginUser];
    [[V2TIMManager sharedInstance] getUsersInfo:@[loginUser] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
        NSString *showName = loginUser;
        if (infoList.firstObject.nickName.length > 0) {
            showName = infoList.firstObject.nickName;
        }
        NSMutableString *groupName = [NSMutableString stringWithString:showName];
        NSMutableArray *members = [NSMutableArray array];
        for (TUICommonContactSelectCellData *item in contacts) {
            V2TIMCreateGroupMemberInfo *member = [[V2TIMCreateGroupMemberInfo alloc] init];
            member.userID = item.identifier;
            member.role = V2TIM_GROUP_MEMBER_ROLE_MEMBER;
            [groupName appendFormat:@"、%@", item.title];
            [members addObject:member];
        }

        if ([groupName length] > 10) {
            groupName = [groupName substringToIndex:10].mutableCopy;
        }

        V2TIMGroupInfo *info = [[V2TIMGroupInfo alloc] init];
        info.groupName = groupName;
        info.groupType = groupType;
        if(![info.groupType isEqualToString:GroupType_Work]){
            info.groupAddOpt = createOption;
        }

        [[V2TIMManager sharedInstance] createGroup:info memberList:members succ:^(NSString *groupID) {
            NSString *content = nil;
            if([info.groupType isEqualToString:GroupType_Work]) {
                content = TUIKitLocalizableString(ChatsCreatePrivateGroupTips);
            } else if([info.groupType isEqualToString:GroupType_Public]){
                content = TUIKitLocalizableString(ChatsCreateGroupTips);
            } else if([info.groupType isEqualToString:GroupType_Meeting]) {
                content = TUIKitLocalizableString(ChatsCreateChatRoomTips);
            } else if([info.groupType isEqualToString:GroupType_Community]) {
                content = TUIKitLocalizableString(ChatsCreateCommunityTips);
            } else {
                content = TUIKitLocalizableString(ChatsCreateDefaultTips);
            }
            NSDictionary *dic = @{@"version": @(GroupCreate_Version),
                                  BussinessID: BussinessID_GroupCreate,
                                  @"opUser": showName,
                                  @"content": content
            };
            NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:data];
            [[V2TIMManager sharedInstance] sendMessage:msg receiver:nil groupID:groupID priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:nil succ:nil fail:nil];
            // wait for a second to ensure the group created message arrives first
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(YES, groupID, groupName);
                }
            });
        } fail:^(int code, NSString *msg) {
            if (completion) {
                completion(NO, nil, nil);
            }
            if (code == ERR_SDK_INTERFACE_NOT_SUPPORT) {
                [TUITool postUnsupportNotificationOfService:TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceCommunity) serviceDesc:TUIKitLocalizableString(TUIKitErrorUnsupportIntefaceCommunityDesc) debugOnly:YES];
            }
        }];
    } fail:^(int code, NSString *msg) {
        if (completion) {
            completion(NO, nil, nil);
        }
    }];
}

#pragma mark - TUIServiceProtocol
- (id)onCall:(NSString *)method param:(NSDictionary *)param{
    id returnObject = nil;
    if ([method isEqualToString:TUICore_TUIGroupService_GetGroupRequestViewControllerMethod]) {
        returnObject = [self createGroupRequestViewController:[param tui_objectForKey:TUICore_TUIGroupService_GetGroupRequestViewControllerMethod_GroupInfoKey
                                                                       asClass:V2TIMGroupInfo.class]];
        
    } else if ([method isEqualToString:TUICore_TUIGroupService_GetGroupInfoControllerMethod]) {
        returnObject = [self createGroupInfoController:[param tui_objectForKey:TUICore_TUIGroupService_GetGroupInfoControllerMethod_GroupIDKey
                                                                       asClass:NSString.class]];
        
    } else if ([method isEqualToString:TUICore_TUIGroupService_GetSelectGroupMemberViewControllerMethod]) {
        NSString *groupID            = [param tui_objectForKey:TUICore_TUIGroupService_GetSelectGroupMemberViewControllerMethod_GroupIDKey
                                                      asClass:NSString.class];
        NSString *title              = [param tui_objectForKey:TUICore_TUIGroupService_GetSelectGroupMemberViewControllerMethod_NameKey
                                                      asClass:NSString.class];
        NSNumber *optionalStyleNum   = [param tui_objectForKey:TUICore_TUIGroupService_GetSelectGroupMemberViewControllerMethod_OptionalStyleKey
                                                     asClass:NSNumber.class];
        NSArray  *selectedUserIDList = [param tui_objectForKey:TUICore_TUIGroupService_GetSelectGroupMemberViewControllerMethod_SelectedUserIDListKey
                                                      asClass:NSArray.class];
        NSString *userData           = [param tui_objectForKey:TUICore_TUIGroupService_GetSelectGroupMemberViewControllerMethod_UserDataKey asClass:NSString.class];
        
        returnObject = [self createSelectGroupMemberViewController:groupID
                                                              name:title
                                                     optionalStyle:[optionalStyleNum integerValue]
                                                selectedUserIDList:selectedUserIDList
                                                          userData:userData];
        
    } else if ([method isEqualToString:TUICore_TUIGroupService_CreateGroupMethod]) {
        NSString *groupType = [param tui_objectForKey:TUICore_TUIGroupService_CreateGroupMethod_GroupTypeKey asClass:NSString.class];
        NSNumber *option    = [param tui_objectForKey:TUICore_TUIGroupService_CreateGroupMethod_OptionKey asClass:NSNumber.class];
        NSArray  *contacts  = [param tui_objectForKey:TUICore_TUIGroupService_CreateGroupMethod_ContactsKey asClass:NSArray.class];
        void (^completion)(BOOL, NSString *, NSString *) = [param objectForKey:TUICore_TUIGroupService_CreateGroupMethod_CompletionKey];
        
        [self createGroup:groupType
             createOption:[option intValue]
                 contacts:contacts
               completion:completion];
    }
    return returnObject;
}
@end
