# frozen_string_literal: true

require_relative 'lib/dashamail/version'

Gem::Specification.new do |spec|
  spec.name = 'dashamail_transactional'
  spec.version = DashaMail::VERSION
  spec.authors = ['Sergey Fedorov']
  spec.email = ['creadone@gmail.com']

  spec.summary = 'Ruby client DashaMail for transactional API'
  spec.description = 'Ruby client DashaMail for transactional API'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = 'https://github.com/83312d/dashamail_transactional'
  spec.metadata['source_code_uri'] = 'https://github.com/83312d/dashamail_transactional'

  spec.add_dependency 'mime-types', '>= 3.4.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
