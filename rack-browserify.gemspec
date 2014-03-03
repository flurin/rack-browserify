# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/browserify/version'

Gem::Specification.new do |s|
  s.name = "rack-browserify"
  s.version = Rack::Browserify::VERSION
  
  s.authors = ["Flurin Egger"]
  s.email = ["info@digitpaint.nl", "flurin@digitpaint.nl"]  
  s.homepage = "http://github.com/flurin/rack-browserify"
  s.summary = "Run Browserify directly as rack middleware"
  s.licenses = ["MIT"]

  s.date = Time.now.strftime("%Y-%m-%d")

  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]  
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]  
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.add_dependency("rack", [">= 1.0.0"])
end
