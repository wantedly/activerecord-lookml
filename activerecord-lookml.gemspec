require_relative 'lib/activerecord/lookml/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-lookml"
  spec.version       = ActiveRecord::LookML::VERSION
  spec.authors       = ["Yoshinori Kawasaki"]
  spec.email         = ["yoshi@wantedly.com"]

  spec.summary       = %q{ActiveRecord extension for LookML (Looker)}
  spec.description   = %q{[Experimental] Generate LookML}
  spec.homepage      = "https://github.com/wantedly/activerecord-lookml"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wantedly/activerecord-lookml"
  spec.metadata["changelog_uri"] = "https://github.com/wantedly/activerecord-lookml/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 6'
  spec.add_dependency 'activerecord', '>= 6'

  spec.add_development_dependency 'activerecord', '>= 6'
end
