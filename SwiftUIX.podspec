
Pod::Spec.new do |spec|
    spec.name         = "SwiftUIX"
    spec.version      = "0.2.3"
    spec.summary      = "An exhaustive expansion of the standard SwiftUI library."
    spec.description  = <<-DESC
An exhaustive expansion of the standard SwiftUI library.
                   DESC
    spec.homepage     = "https://github.com/SwiftUIX/SwiftUIX"
    spec.license      = { :type => "MIT", :file => "LICENCE.md" }
    spec.author             = "Vatsal Manot"
    spec.social_media_url   = ""

    spec.ios.deployment_target = "13.0"
    spec.macos.deployment_target = "11.0"
    spec.tvos.deployment_target = "13.0"
    spec.watchos.deployment_target = "6.0"

    spec.source = { :git => "git@github.com:adityadaniel/SwiftUIX.git", :branch => "feature/goat" }

    spec.source_files  = "Sources/**/*.{swift}"
    spec.swift_version = "5.1"
    spec.framework  = "SwiftUI"
  
end
