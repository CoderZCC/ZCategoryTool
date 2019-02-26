Pod::Spec.new do |spec|

spec.name         = "ZCategoryTool"
spec.version      = "1.0.9"
spec.summary      = "An Extension Tool for Swift."
spec.description  = <<-DESC
               Tool Integration for Improving Development Efficiency.
               DESC
spec.homepage     = "https://github.com/CoderZCC/ZCategoryTool"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "ZCC" => "coderzcc@163.com" }
spec.platform     = :ios
spec.ios.deployment_target = "9.0"
spec.source       = { :git => "https://github.com/CoderZCC/ZCategoryTool.git", :tag => "#{spec.version}" }
spec.source_files  = "ZCategoryTool/**/*.{swift}"
spec.requires_arc = true
spec.swift_version = '4.2'

end
