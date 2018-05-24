Pod::Spec.new do |s|
  s.name         = "MultilevelMenu"
  s.version      = "1.2.0"
  s.summary      = "MultilevelMenu"
  s.description  = "MultilevelMenu"
  s.homepage     = "https://github.com/ChokShen/MultilevelMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "shenzhiqiang" => "295297647@qq.com" }
  s.ios.deployment_target = '10.0'
  s.source       = { :git => "git@github.com:ChokShen/MultilevelMenu.git", :tag => "1.2.0" }
  s.source_files  = "MultilevelMenu/Source/**/*.swift"
  s.resources = "MultilevelMenu/Resources/*.png"
  s.framework  = 'Foundation', 'UIKit'
  s.requires_arc = true
end
