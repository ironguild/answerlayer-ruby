# frozen_string_literal: true

require_relative "lib/answerlayer/version"

Gem::Specification.new do |spec|
  spec.name = "answerlayer"
  spec.version = AnswerLayer::VERSION
  spec.authors = [ "AnswerLayer Maintainers" ]
  spec.email = [ "matt@answerlayer.com" ]

  spec.summary = "Ruby API wrapper for the AnswerLayer API."
  spec.description = "A dependency-light Ruby client for AnswerLayer connections, queries, inquiry sessions, saved queries, dashboards, query results, semantic-layer APIs, and identity broker APIs."
  spec.homepage = "https://github.com/ironguild/answerlayer-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    Dir["lib/**/*.rb", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  end

  spec.require_paths = [ "lib" ]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
end
