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

  s.date = %q{2021-09-24}
  s.files = ["lib/bank_card_cn_query.rb"]
end
