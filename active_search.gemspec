# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_search/version"

Gem::Specification.new do |s|
  s.name        = "active_search"
  s.version     = ActiveSearch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Rob Cameron, Active Network']
  s.email       = ['rob.cameron@active.com']
  s.homepage    = "http://developer.active.com/docs/read/Activecom_Search_API_Reference"
  s.summary     = %q{This gem abstracts the Active.com Search API}
  s.description = %q{Use this gem to search the Active.com Search API. See http://developer.active.com to request a key to get started.}

  s.rubyforge_project = "active_search"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency('httparty')
  s.add_runtime_dependency('json')
end
