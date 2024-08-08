
Pod::Spec.new do |spec|
  spec.name         = 'TXIMSDK_Plus_iOS_XCFramework'
  spec.version      = '8.1.6103'
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.license      = { :type => 'Proprietary',
      :text => <<-LICENSE
        copyright 2017 tencent Ltd. All rights reserved.
        LICENSE
       }
  spec.homepage     = 'https://cloud.tencent.com/document/product/269/3794'
  spec.documentation_url = 'https://cloud.tencent.com/document/product/269/9147'
  spec.authors      = 'tencent video cloud'
  spec.summary      = 'TXIMSDK_Plus_iOS_XCFramework'
  
  spec.requires_arc = true

  spec.source = { :http => 'https://im.sdk.cloud.tencent.cn/download/plus/8.1.6103/ImSDK_Plus_8.1.6103.xcframework.zip'}
  spec.vendored_frameworks = '**/ImSDK_Plus.xcframework'
  spec.resource_bundle = {
    "#{spec.module_name}_Privacy" => '**/ImSDK_Plus.xcframework/ios-arm64_armv7/ImSDK_Plus.framework/PrivacyInfo.xcprivacy'
  }
end
