//
//  TUIMergeMessageCell.m
//  Pods
//
//  Created by harvy on 2020/12/9.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUIMergeMessageCell_Minimalist.h"
#import <TIMCommon/TIMDefine.h>
#import <TUICore/TUIThemeManager.h>

#ifndef CGFLOAT_CEIL
#ifdef CGFLOAT_IS_DOUBLE
#define CGFLOAT_CEIL(value) ceil(value)
#else
#define CGFLOAT_CEIL(value) ceilf(value)
#endif
#endif

@interface TUIMergeMessageDetailRow_Minimalist : UIView
@property(nonatomic, strong) UILabel *abstractName;
@property(nonatomic, strong) UILabel *abstractBreak;
@property(nonatomic, strong) UILabel *abstractDetail;
- (void)fillWithData:(NSAttributedString *)name detailContent:(NSAttributedString *)detailContent;
@end
@implementation TUIMergeMessageDetailRow_Minimalist

- (instancetype)init {
    self = [super init];
    if(self){
        [self setupview];
    }
    return self;
}
- (void)setupview {
    [self addSubview:self.abstractName];
    [self addSubview:self.abstractBreak];
    [self addSubview:self.abstractDetail];
}

- (UILabel *)abstractName {
    if(!_abstractName) {
        _abstractName = [[UILabel alloc] init];
        _abstractName.numberOfLines = 1;
        _abstractName.font = [UIFont systemFontOfSize:12.0];
        _abstractName.textColor = [UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1 / 1.0];
        _abstractName.textAlignment = isRTL()? NSTextAlignmentRight:NSTextAlignmentLeft;
    }
    return _abstractName;
}
- (UILabel *)abstractBreak {
    if(!_abstractBreak) {
        _abstractBreak = [[UILabel alloc] init];
        _abstractBreak.text = @":";
        _abstractBreak.font = [UIFont systemFontOfSize:12.0];
        _abstractBreak.textColor = TUIChatDynamicColor(@"chat_merge_message_content_color", @"#d5d5d5");
    }
    return _abstractBreak;
}
- (UILabel *)abstractDetail {
    if(!_abstractDetail) {
        _abstractDetail = [[UILabel alloc] init];
        _abstractDetail.numberOfLines = 0;
        _abstractName.font = [UIFont systemFontOfSize:12.0];
        _abstractDetail.textColor = TUIChatDynamicColor(@"chat_merge_message_content_color", @"#d5d5d5");
        _abstractDetail.textAlignment = isRTL()? NSTextAlignmentRight:NSTextAlignmentLeft;
    }
    return _abstractDetail;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    
    [super updateConstraints];
    [self.abstractName sizeToFit];
    [self.abstractName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.trailing.mas_lessThanOrEqualTo(self.abstractBreak.mas_leading);
        make.width.mas_lessThanOrEqualTo(self.mas_width).multipliedBy(0.33);
    }];
    
    [self.abstractBreak sizeToFit];
    [self.abstractBreak mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.abstractName.mas_trailing);
        make.top.mas_equalTo(self.abstractName);
        make.width.mas_offset(self.abstractBreak.frame.size.width);
        make.height.mas_offset(self.abstractBreak.frame.size.height);
    }];
    
    [self.abstractDetail sizeToFit];
    [self.abstractDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.abstractBreak.mas_trailing);
        make.top.mas_equalTo(0);
        make.trailing.mas_lessThanOrEqualTo(self.mas_trailing).mas_offset(-15);
        make.bottom.mas_equalTo(self);
    }];
}
- (void)fillWithData:(NSAttributedString *)name detailContent:(NSAttributedString *)detailContent {

    self.abstractName.text = name.string;
    self.abstractDetail.attributedText = detailContent;
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];

    [self layoutIfNeeded];

    
}
- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
@interface TUIMergeMessageCell_Minimalist ()

@property(nonatomic, strong) CAShapeLayer *borderLayer;
@property(nonatomic, strong) TUIMergeMessageDetailRow_Minimalist *contentRowView1;
@property(nonatomic, strong) TUIMergeMessageDetailRow_Minimalist *contentRowView2;
@property(nonatomic, strong) TUIMergeMessageDetailRow_Minimalist *contentRowView3;

@end
@implementation TUIMergeMessageCell_Minimalist

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.container.backgroundColor = RGBA(249, 249, 249, 0.94);

    _relayTitleLabel = [[UILabel alloc] init];
    _relayTitleLabel.text = @"Chat history";
    _relayTitleLabel.font = [UIFont systemFontOfSize:12];
    _relayTitleLabel.textColor = RGBA(0, 0, 0, 0.8);
    [self.container addSubview:_relayTitleLabel];

    _contentRowView1 = [[TUIMergeMessageDetailRow_Minimalist alloc] init];
    [self.container addSubview:_contentRowView1];
    _contentRowView2 = [[TUIMergeMessageDetailRow_Minimalist alloc] init];
    [self.container addSubview:_contentRowView2];
    _contentRowView3 = [[TUIMergeMessageDetailRow_Minimalist alloc] init];
    [self.container addSubview:_contentRowView3];

    _separtorView = [[UIView alloc] init];
    _separtorView.backgroundColor = TIMCommonDynamicColor(@"separator_color", @"#DBDBDB");
    [self.container addSubview:_separtorView];

    _bottomTipsLabel = [[UILabel alloc] init];
    _bottomTipsLabel.text = TIMCommonLocalizableString(TUIKitRelayChatHistory);
    _bottomTipsLabel.textColor = RGBA(153, 153, 153, 1);
    _bottomTipsLabel.font = [UIFont systemFontOfSize:10];
    [self.container addSubview:_bottomTipsLabel];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
     
    [super updateConstraints];

    [self.relayTitleLabel sizeToFit];
    [self.relayTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.container).mas_offset(10);
        make.width.mas_lessThanOrEqualTo(self.container);
        make.height.mas_equalTo(self.relayTitleLabel.font.lineHeight);
        make.top.mas_equalTo(self.container).mas_offset(10);
    }];
    
    [self.contentRowView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.relayTitleLabel);
        make.top.mas_equalTo(self.relayTitleLabel.mas_bottom).mas_offset(3);
        make.trailing.mas_equalTo(self.container);
        make.height.mas_equalTo(self.relayData.abstractRow1Size.height);
    }];

    [self.contentRowView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.relayTitleLabel);
        make.top.mas_equalTo(self.contentRowView1.mas_bottom).mas_offset(3);
        make.trailing.mas_equalTo(self.container);
        make.height.mas_equalTo(self.relayData.abstractRow2Size.height);
    }];

    [self.contentRowView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.relayTitleLabel);
        make.top.mas_equalTo(self.contentRowView2.mas_bottom).mas_offset(3);
        make.trailing.mas_equalTo(self.container);
        make.height.mas_equalTo(self.relayData.abstractRow3Size.height);
    }];
    
    UIView *lastView =  self.contentRowView1;
    int count = self.relayData.abstractSendDetailList.count;
    if (count == 3) {
        lastView = self.contentRowView3;
    }
    else if (count == 2){
        lastView = self.contentRowView2;
    }
    [self.separtorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.container).mas_offset(10);
        make.trailing.mas_equalTo(self.container).mas_offset(-10);
        make.top.mas_equalTo(lastView.mas_bottom).mas_offset(3);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentRowView1);
        make.top.mas_equalTo(self.separtorView.mas_bottom).mas_offset(5);
        make.width.mas_lessThanOrEqualTo(self.container);
        make.height.mas_equalTo(self.bottomTipsLabel.font.lineHeight);
    }];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)fillWithData:(TUIMergeMessageCellData *)data {
    [super fillWithData:data];
    self.relayData = data;
    self.relayTitleLabel.text = data.title;
    int count = self.relayData.abstractSendDetailList.count;
    switch (count) {
        case 1:
            [self.contentRowView1 fillWithData:self.relayData.abstractSendDetailList[0][@"sender"] detailContent:self.relayData.abstractSendDetailList[0][@"detail"]];
            self.contentRowView1.hidden = NO;
            self.contentRowView2.hidden = YES;
            self.contentRowView3.hidden = YES;
            break;
        case 2:
            [self.contentRowView1 fillWithData:self.relayData.abstractSendDetailList[0][@"sender"] detailContent:self.relayData.abstractSendDetailList[0][@"detail"]];
            [self.contentRowView2 fillWithData:self.relayData.abstractSendDetailList[1][@"sender"] detailContent:self.relayData.abstractSendDetailList[1][@"detail"]];

            self.contentRowView1.hidden = NO;
            self.contentRowView2.hidden = NO;
            self.contentRowView3.hidden = YES;
            break;
        case 3:
            
            [self.contentRowView1 fillWithData:self.relayData.abstractSendDetailList[0][@"sender"] detailContent:self.relayData.abstractSendDetailList[0][@"detail"]];
            [self.contentRowView2 fillWithData:self.relayData.abstractSendDetailList[1][@"sender"] detailContent:self.relayData.abstractSendDetailList[1][@"detail"]];
            [self.contentRowView3 fillWithData:self.relayData.abstractSendDetailList[2][@"sender"] detailContent:self.relayData.abstractSendDetailList[2][@"detail"]];
            self.contentRowView1.hidden = NO;
            self.contentRowView2.hidden = NO;
            self.contentRowView3.hidden = NO;
            break;
        default:
            break;
    }
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];

    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];

    [self layoutIfNeeded];

}


#pragma mark - TUIMessageCellProtocol
+ (CGSize)getContentSize:(TUIMessageCellData *)data {
    NSAssert([data isKindOfClass:TUIMergeMessageCellData.class], @"data must be kind of TUIMergeMessageCellData");
    TUIMergeMessageCellData *mergeCellData = (TUIMergeMessageCellData *)data;
    
    mergeCellData.abstractRow1Size = [self.class caculate:mergeCellData index:0];
    mergeCellData.abstractRow2Size = [self.class caculate:mergeCellData index:1];
    mergeCellData.abstractRow3Size = [self.class caculate:mergeCellData index:2];

    CGRect rect = [[mergeCellData abstractAttributedString] boundingRectWithSize:CGSizeMake(200 - 20, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                context:nil];
    CGSize size = CGSizeMake(CGFLOAT_CEIL(rect.size.width), CGFLOAT_CEIL(rect.size.height) - 10);
    mergeCellData.abstractSize = size;
    CGFloat height = mergeCellData.abstractRow1Size.height + mergeCellData.abstractRow2Size.height + mergeCellData.abstractRow3Size.height;
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    height = (10 + titleFont.lineHeight + 3) + height + 1 + 5 + 20 + 5 + 3;
    return CGSizeMake(kScale390(250), height + mergeCellData.msgStatusSize.height);
}

+ (CGSize)caculate:(TUIMergeMessageCellData *)data index:(NSInteger)index {
    
    NSArray<NSDictionary *> *abstractSendDetailList = data.abstractSendDetailList;
    if (abstractSendDetailList.count <= index){
        return CGSizeZero;
    }
    NSAttributedString * str = abstractSendDetailList[index][@"sender"];
    NSMutableAttributedString *abstr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [abstr appendAttributedString:[[NSAttributedString alloc] initWithString:@":"]];
    [abstr appendAttributedString:abstractSendDetailList[index][@"detail"]];

    CGRect rect = [abstr boundingRectWithSize:CGSizeMake(200 - 20, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                context:nil];
    CGSize size = CGSizeMake(200, MIN(TRelayMessageCell_Text_Height_Max/3.0, CGFLOAT_CEIL(rect.size.height)));

    return size;
}

@end
