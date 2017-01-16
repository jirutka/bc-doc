source 'https://rubygems.org'

# Windows does not come with time zone data
gem 'tzinfo-data', platforms: [:mswin, :mingw, :jruby]

# Natural sorting
gem 'naturally', '~> 2.1'

# CSS framework used in Asciidoctor styles
gem 'zurb-foundation', '~> 4.3.2'

# Syntax highlighter
gem 'coderay', '~> 1.1'

# Middleman Gems
gem 'middleman-core', '~> 4.1'
gem 'middleman-cli', '~> 4.1'
gem 'middleman-asciidoc'
gem 'kramdown', '~> 1.2'

# This fork just removes platform-specific dependencies from gemspec.
# See https://github.com/guard/listen/issues/416
# Required by middleman-core: listen ~> 3.0.0
gem 'listen', git: 'https://github.com/jirutka/listen.git', tag: 'v3.0.8-nodep-r1'

# Gems for live reload etc.
group :development do
  gem 'middleman-livereload', '~> 3.4'

  # Optional dependencies of the listen gem for faster file watcher updates
  # on specific platform.
  install_if -> { RUBY_PLATFORM =~ /linux/ } do
    gem 'rb-inotify', '~> 0.9', '>= 0.9.7'
  end
  install_if -> { RUBY_PLATFORM =~ /mingw|mswin/i } do
    gem 'wdm', '~> 0.1.0', platforms: [:mswin, :mingw, :x64_mingw]
  end
  install_if -> { RUBY_PLATFORM =~ /darwin/ } do
    gem 'rb-fsevent', '~> 0.9', '>= 0.9.4'
  end
end
