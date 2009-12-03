# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{summary_judgement}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl"]
  s.date = %q{2009-12-03}
  s.description = %q{Constructs adaptive summaries of object hierarchies based on ActiveRecord associations and other simple relationship structures}
  s.email = %q{andy@rossmeissl.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/summary_judgement.rb",
     "lib/summary_judgement/core_extensions.rb",
     "lib/summary_judgement/descriptor.rb",
     "lib/summary_judgement/instance_methods.rb",
     "lib/summary_judgement/summary.rb",
     "summary_judgement.gemspec",
     "test/helper.rb",
     "test/test_summary_judgement.rb"
  ]
  s.homepage = %q{http://github.com/rossmeissl/summary_judgement}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Dynamic summaries of rich object hierarchies}
  s.test_files = [
    "test/helper.rb",
     "test/test_summary_judgement.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

