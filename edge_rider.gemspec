$:.push File.expand_path("../lib", __FILE__)
require "edge_rider/version"

Gem::Specification.new do |s|
  s.name = 'edge_rider'
  s.version = EdgeRider::VERSION
  s.authors = ["Henning Koch"]
  s.email = 'henning.koch@makandra.de'
  s.homepage = 'https://github.com/makandra/edge_rider'
  s.summary = 'Power tools for ActiveRecord relations (scopes)'
  s.description = s.summary
  s.license = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rails')

end
