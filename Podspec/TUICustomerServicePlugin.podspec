Pod::Spec.new do |spec|
  spec.name         = 'TUICustomerServicePlugin'
  spec.version      = '7.9.5666'
  spec.platform     = :ios
  spec.ios.deployment_target = '10.0'
  spec.license      = { :type => 'Proprietary',
      :text => <<-LICENSE
        copyright 2017 tencent Ltd. All rights reserved.
        LICENSE
       }
  spec.homepage     = 'https://cloud.tencent.com/document/product/269/3794'
  spec.documentation_url = 'https://cloud.tencent.com/document/product/269/9147'
  spec.authors      = 'tencent video cloud'
  spec.summary      = 'TUICustomerServicePlugin'
  spec.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64', }

  spec.requires_arc = true

  spec.source = { :http => 'https://im.sdk.cloud.tencent.cn/download/tuikit/7.9.5666/ios/TUICustomerServicePlugin.zip'}

  spec.default_subspec = 'ALL'

  spec.subspec 'CommonModel' do |commonModel|
    commonModel.source_files = '**/TUICustomerServicePlugin/CommonModel/*.{h,m,mm}'
    commonModel.dependency 'TUICore'
    commonModel.dependency 'TIMCommon', '~> 7.9.5666'
    commonModel.dependency 'TUIChat', '~> 7.9.5666'
    commonModel.dependency 'TUIContact','~> 7.9.5666'
  end

  spec.subspec 'UI_Classic' do |commonUI|
    commonUI.subspec 'DataProvider' do |dataProvider|
      dataProvider.source_files = '**/TUICustomerServicePlugin/UI_Classic/DataProvider/*.{h,m,mm}'
      dataProvider.dependency "TUICustomerServicePlugin/CommonModel"
    end
    commonUI.subspec 'BaseCell' do |baseCell|
      baseCell.source_files = '**/TUICustomerServicePlugin/UI_Classic/BaseCell/*.{h,m,mm}'
      baseCell.dependency "TUICustomerServicePlugin/UI_Classic/DataProvider"
    end
    commonUI.subspec 'UI' do |subUI|
      subUI.source_files = '**/TUICustomerServicePlugin/UI_Classic/UI/*.{h,m,mm}'
      subUI.dependency "TUICustomerServicePlugin/UI_Classic/BaseCell"
    end
    commonUI.subspec 'Service' do |service|
      service.source_files = '**/TUICustomerServicePlugin/UI_Classic/Service/*.{h,m,mm}'
      service.dependency "TUICustomerServicePlugin/UI_Classic/UI"
    end
    commonUI.resource = [
      '**/TUICustomerServicePlugin/Resources/*.bundle',
      '**/TUICustomerServicePlugin/Resources/PrivacyInfo.xcprivacy'
    ]
  end

  spec.subspec 'ALL' do |all|
    all.dependency "TUICustomerServicePlugin/UI_Classic"
  end

  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'GENERATE_INFOPLIST_FILE' => 'YES'
  }
  spec.user_target_xcconfig = { 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'GENERATE_INFOPLIST_FILE' => 'YES'
  }
end

# pod trunk push TUICustomerServicePlugin.podspec --use-libraries --allow-warnings