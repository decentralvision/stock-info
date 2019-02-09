lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stock_info/version'

Gem::Specification.new do |spec|
  spec.name          = 'stock_info'
  spec.version       = StockInfo::VERSION
  spec.authors       = ['Tom Kunkel']
  spec.email         = ['36858744+decentralvision@users.noreply.github.com']

  spec.summary       = 'Simple gem providing stock info from finviz.com'
  spec.description   = "This CLI gem provides data and news articles from finviz.com, run the program with 'stock-info'. Commands are provided via prompts in the interface."
  spec.homepage      = 'https://github.com/decentralvision/stock-info'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'bin'
  spec.executables << 'stock-info'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'nokogiri', '~> 1.10'
end
