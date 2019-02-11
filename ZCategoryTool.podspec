Pod::Spec.new do |spec|

  spec.name         = "ZCategoryTool"
  spec.version      = "0.0.2"
  spec.summary      = "a category tool for swift language"
  spec.description  = <<-DESC
                    a category tool for swift language.a category tool for swift language.a category tool for swift language.a category tool for swift language.
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
