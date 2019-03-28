Pod::Spec.new do |s|
    s.author       = { "ZCC" => "coderzcc@163.com" }
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.requires_arc = true
    s.version      = "1.1.6"
    s.homepage     = "https://github.com/CoderZCC/ZCategoryTool"
    s.name         = "ZCategoryTool"

    s.source_files = "ZCategoryTool/**/*.{swift,h,m}"
    s.source       = { :git => "https://github.com/CoderZCC/ZCategoryTool.git", :tag => "#{s.version}" }

    s.summary      = "An Extension Tool for Swift."
    s.description  = "Tool Integration for Improving Development Efficiency."

    s.platform     = :ios
    s.ios.deployment_target = "9.0"
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
end
