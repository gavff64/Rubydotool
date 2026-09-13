require_relative "lib/rubydotool/version"

Gem::Specification.new do |spec|
  spec.name = "rubydotool"
  spec.version = Rubydotool::VERSION
  spec.summary = "A small Ruby wrapper for ydotool"
  spec.description = "A small Ruby API for keyboard and mouse input through ydotool."
  spec.authors = ["gavff"]
  spec.homepage = "https://github.com/gavff64/rubydotool"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"
  spec.files = Dir["lib/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end
