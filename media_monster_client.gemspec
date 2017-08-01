# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "media_monster_client/version"

Gem::Specification.new do |s|
  s.name        = "media_monster_client"
  s.version     = MediaMonsterClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Kuklewicz (kookster)"]
  s.email       = ["andrew@prx.org"]
  s.homepage    = ""
  s.summary     = %q{client gem for media monster app}
  s.description = %q{client gem for media monster app}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("activesupport", "~> 2.3.18")
  s.add_runtime_dependency("oauth", "~> 0.4.7")
  s.add_runtime_dependency("json")
  s.add_runtime_dependency("i18n", "~> 0.6.1")

  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  s.add_development_dependency 'fakeweb'
end
