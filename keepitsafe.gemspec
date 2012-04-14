# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "keepitsafe"
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Darwin"]
  s.date = "2012-04-14"
  s.description = "A Gem for simple creation of backup scripts"
  s.email = "darwin.git@marianna.se"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "email/error/error.html.erb",
    "email/report/report.html.erb",
    "example/localhost.rb",
    "example/server.com.rb",
    "features/keepitsafe.feature",
    "features/step_definitions/keepitsafe_steps.rb",
    "features/support/env.rb",
    "keepitsafe.gemspec",
    "lib/backup.rb",
    "lib/backup_report.rb",
    "lib/error_mail.rb",
    "lib/events.rb",
    "lib/keepitsafe.rb",
    "lib/plugins/files.rb",
    "lib/plugins/mongo.rb",
    "lib/plugins/postgres.rb",
    "lib/plugins/remove.rb",
    "lib/plugins/rsync.rb",
    "lib/plugins/scp.rb",
    "lib/plugins/tar.rb",
    "lib/stdcapture.rb",
    "spec/keepitsafe_spec.rb",
    "spec/spec_helper.rb",
    "todo.txt"
  ]
  s.homepage = "http://github.com/bjornblomqvist/keepitsafe"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "A Gem for simple creation of backup scripts"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<net-ssh>, [">= 0"])
      s.add_runtime_dependency(%q<net-scp>, [">= 0"])
      s.add_runtime_dependency(%q<net-sftp>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<mail>, [">= 0"])
      s.add_runtime_dependency(%q<mailbuilder>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<net-ssh>, [">= 0"])
      s.add_dependency(%q<net-scp>, [">= 0"])
      s.add_dependency(%q<net-sftp>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<mail>, [">= 0"])
      s.add_dependency(%q<mailbuilder>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<net-ssh>, [">= 0"])
    s.add_dependency(%q<net-scp>, [">= 0"])
    s.add_dependency(%q<net-sftp>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<mail>, [">= 0"])
    s.add_dependency(%q<mailbuilder>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
  end
end

