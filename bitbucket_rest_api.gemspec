# -*- encoding: utf-8 -*-

$:.push File.expand_path("lib", __dir__)
require File.expand_path("lib/bitbucket_rest_api/version", __dir__)

Gem::Specification.new do |gem|
  gem.name          = "bitbucket_rest_api"
  gem.authors       = [ "Mike Cochran" ]
  gem.email         = "mcochran@linux.com"
  gem.homepage      = "https://github.com/vongrippen/bitbucket"
  gem.summary       = " Ruby wrapper for the BitBucket API supporting OAuth and Basic Authentication "
  gem.description   = " Ruby wrapper for the BitBucket API supporting OAuth and Basic Authentication "
  gem.version       = BitBucket::VERSION::STRING.dup
  gem.license       = "MIT"
  gem.required_ruby_version = ">= 3.2"

  gem.files = Dir["Rakefile", "{features,lib,spec}/**/*", "README*", "LICENSE*"]
  gem.require_paths = %w[ lib ]

  gem.add_dependency "faraday", ">= 2.0"
  gem.add_dependency "faraday-multipart"
  gem.add_dependency "faraday-oauth1"
  gem.add_dependency "hashie"
  gem.add_dependency "multi_json", ">= 1.7.5", "< 2.0"
  gem.add_dependency "nokogiri", ">= 1.5.2"
  gem.add_dependency "simple_oauth"

  gem.metadata["rubygems_mfa_required"] = "true"
end
