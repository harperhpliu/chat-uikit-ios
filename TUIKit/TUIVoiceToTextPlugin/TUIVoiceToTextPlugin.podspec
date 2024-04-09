Pod::Spec.new do |spec|
  spec.name         = 'TUIVoiceToTextPlugin'
  spec.version      = '7.9.5666'
  spec.platform     = :ios 
  spec.ios.deployment_target = '9.0'
  spec.license      = { :type => 'Proprietary',
      :text => <<-LICENSE
        copyright 2017 tencent Ltd. All rights reserved.
        LICENSE
       }
  spec.homepage     = 'https://cloud.tencent.com/document/product/269/3794'
  spec.documentation_url = 'https://cloud.tencent.com/document/product/269/9147'
  spec.authors      = 'tencent video cloud'
  spec.summary      = 'TUIVoiceToTextPlugin'
  spec.dependency 'TUICore'
  spec.dependency 'TIMCommon'
  spec.dependency 'TUIChat'
  
  spec.requires_arc = true

  spec.source = { :git => 'https://git.woa.com/lynxzhang/tui-components.git', :tag => spec.version}
  spec.source_files = '**/*.{h,m,mm,c}'
  spec.resource = [
  'Resources/*.bundle','Resources/PrivacyInfo.xcprivacy'
  ]
end
