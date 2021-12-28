# frozen_string_literal: true

require_relative "lib/what_is_this/version"

Gem::Specification.new do |spec|
  spec.name = "what_is_this"
  spec.version = WhatIsThis::VERSION
  spec.authors = ["D-Justice"]
  spec.email = ["justice.damian96@gmail.com"]

  spec.summary = "CLI that allows the user all the functionality of RubyGems.org within the terminal."
  spec.description = "CLI that allows the user all the functionality of RubyGems.org within the terminal."
  spec.homepage = "https://github.com/D-Justice/what-is-this"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["what_is_this"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
