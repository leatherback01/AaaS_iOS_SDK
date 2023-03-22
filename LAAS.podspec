
Pod::Spec.new do |s|
  s.name             = 'LAAS'
  s.version          = '0.1.3'
  s.summary          = 'An iOS library for accepting payment with LeatherBack.'


  s.description      = <<-DESC
  An iOS library for accepting payment globally (GBP, NGN) using LeatherBack.
                       DESC

  s.homepage         = 'https://github.com/leatherback01/AaaS_iOS_SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Promise Ochornma' => 'promise.ochornma@leatherback.co' }
  s.source           = { :git => 'https://github.com/leatherback01/AaaS_iOS_SDK.git', :tag => s.version.to_s }
  #spec.documentation_url = "https://github.com/leatherback01/AaaS_iOS_SDK/blob/main/README.md"


  s.ios.deployment_target = '11.0'
  s.swift_versions = '5.0'

  s.source_files = 'Sources/LAAS/**/*'
  
   #s.resource_bundles = {
    # 'LAAS' => ['Sources/Assets/*.xcassets']
  # }

   s.frameworks = 'UIKit'
end
