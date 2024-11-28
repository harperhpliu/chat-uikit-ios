Pod::Spec.new do |spec|
  spec.name         = 'TUIPollPlugin'
  spec.version      = '8.3.6498'
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
  spec.summary      = 'TUIPollPlugin'
  
  spec.requires_arc = true

  spec.source = { :http => 'https://im.sdk.cloud.tencent.cn/download/tuiplugin/8.3.6498/ios/TUIPollPlugin_8.3.6498.xcframework.zip'}
  spec.vendored_frameworks = 'TUIPollPlugin.xcframework'
  spec.resource_bundle = {
      "#{spec.module_name}_Privacy" => '**/TUIPollPlugin.xcframework/ios-arm64/TUIPollPlugin.framework/PrivacyInfo.xcprivacy'
  }
end

# pod trunk push TUIPollPlugin.podspec --use-libraries --allow-warnings
