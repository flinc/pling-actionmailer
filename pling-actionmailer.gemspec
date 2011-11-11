# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "pling-actionmailer"
  s.version     = "0.3.0"
  s.authors     = ["benedikt", "t6d", "fabrik42"]
  s.email       = ["benedikt@synatic.net", "me@t6d.de", "fabrik42@gmail.com"]
  s.homepage    = "http://flinc.github.com/pling-actionmailer"
  s.summary     = %q{Pling Gateway to ActionMailer}
  s.description = %q{Pling Gateway to ActionMailer}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "pling", "~> 0.1"
  s.add_runtime_dependency "actionmailer", "~> 3.0"

  s.add_development_dependency "rspec", "~> 2.7"
  s.add_development_dependency "yard", ">= 0.7"
  s.add_development_dependency "rake", ">= 0.9"
end
