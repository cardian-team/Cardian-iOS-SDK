Pod::Spec.new do |spec|
  spec.name = "Cardian"
  spec.version      = "0.9.4"
  spec.summary      = "Cardian is a free service that makes it easy for mobile app developers to build data-driven, health & fitness apps."
  spec.description  = <<-DESC
Cardian is a free service that makes it easy for mobile app developers to build data-driven, health & fitness apps. This plugin simplifies how you integrate your native iOS app with Apple HealthKit to just three lines of code.
DESC
  spec.homepage = "https://cardian.io"
  spec.license = { type: 'Modified MIT', file: 'LICENSE' }
  spec.authors = { "CurAegis Technologies" => 'team@cardian.io' }
  spec.social_media_url = "https://github.com/cardian-team"

  spec.platform = :ios, "12.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/cardian-team/Cardian-iOS-SDK.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "Cardian/**/*.{h,swift}"
  spec.swift_version = "5.0"
  spec.dependency "Alamofire"
end
