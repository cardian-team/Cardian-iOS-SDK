Pod::Spec.new do |spec|
  spec.name = "Cardian"
  spec.version = "1.0.0"
  spec.summary = "Cardian provides developers with the powerful tools they need to create data-driven health & fitness experiences for their users."
  spec.homepage = "https://cardian.io"
  spec.license = { type: 'Modified MIT', file: 'LICENSE' }
  spec.authors = { "CurAegis Technologies" => 'team@cardian.io' }
  spec.social_media_url = "https://github.com/cardian-team"

  spec.platform = :ios, "12.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/cardian-team/Cardian-iOS-SDK.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Cardian/**/*.{h,swift}"
  spec.swift_version = "5.0"

# Dependencies
  # spec.dependency "---", "~> 1.0.0"
end