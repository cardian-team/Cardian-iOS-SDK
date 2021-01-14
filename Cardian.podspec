Pod::Spec.new do |spec|
spec.name         = "Cardian"
spec.version      = "0.9.0"
spec.summary      = "Cardian is a free service that makes it easy for mobile app developers to build data-driven, health & fitness apps."
spec.description  = <<-DESC
Cardian is a free service that makes it easy for mobile app developers to build data-driven, health & fitness apps. This plugin simplifies how you integrate your native iOS app with Apple HealthKit to just three lines of code.
DESC
spec.homepage     = "https://cardian.io"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "author" => "team@cardian.io" }
spec.documentation_url = "https://github.com/cardian-team/Cardian-iOS-SDK"
spec.platforms = { :ios => "12.0", :osx => "10.12", :watchos => "6.0" }
spec.swift_version = "5.3"
spec.source       = { :git => "https://github.com/cardian-team/Cardian-iOS-SDK.git", :tag => "#{spec.version}" }
spec.source_files  = "Sources/Cardian/**/*.swift"
spec.xcconfig = { "SWIFT_VERSION" => "5.3" }
spec.dependency "Alamofire"
end
