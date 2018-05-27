Pod::Spec.new do |s|
  s.name         = "MultilevelMenu"
  s.version      = "1.2.6"
  s.summary      = "MultilevelMenu"
  s.description  = "A custom multi-level menu/ address picker"
  s.homepage     = "https://github.com/ChokShen/MultilevelMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "shenzhiqiang" => "295297647@qq.com" }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/ChokShen/MultilevelMenu.git", :tag => "1.2.6" }
  s.source_files = "MultilevelMenu/Source/**/*.swift"
  s.resources = "MultilevelMenu/Resources/MultilevelMenuBundle.bundle"
  s.framework = 'Foundation', 'UIKit'
  s.requires_arc = true
end
