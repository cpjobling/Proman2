# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{easy_navigation}
  s.version = "3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ivan Torres"]
  s.date = %q{2009-05-14}
  s.description = %q{Easy navigation for Ruby on Rails 2.2 (i18n)}
  s.email = %q{mexpolk@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/easy_navigation.rb"]
  s.files = ["Manifest", "generators/easy_navigation/templates/stylesheets/sass/easy_navigation.sass", "generators/easy_navigation/templates/javascripts/easy_navigation.js", "generators/easy_navigation/templates/images/arrow.png", "generators/easy_navigation/templates/images/arrow.svg", "generators/easy_navigation/easy_navigation_generator.rb", "README.rdoc", "Rakefile", "init.rb", "lib/easy_navigation.rb", "easy_navigation.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/innetra/easy_navigation}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Easy_navigation", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{easy_navigation}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Easy navigation for Ruby on Rails 2.2 (i18n)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
