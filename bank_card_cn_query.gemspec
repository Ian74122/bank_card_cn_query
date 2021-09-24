lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bank_card_cn_query/version"

Gem::Specification.new do |s|
  s.name = "bank_card_cn_query"
  s.version = BankCardCnQuery::VERSION
  s.author = ['Lailaiswz']

  s.summary = %q{query cn bank card info}
  s.description = %q{query cn bank card info}
  s.homepage = "https://github.com/Ian74122/bank_card_cn_query"
  s.licenses = "MIT"

  s.files = Dir.chdir(File.expand_path('..', __FILE__)) do
              `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
            end

  s.require_paths = ["lib"]
  s.files = Dir["{app,config,lib}/**/*", "CHANGELOG.md", "LICENSE", "README.md"]

  s.add_dependency "bundler", "~> 1.17"
  s.add_dependency "rest-client", "~> 2.1"
end
