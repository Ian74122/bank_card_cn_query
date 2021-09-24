# BankCard-Query
check bank card info

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bank_card_cn_query', git: 'https://github.com/Ian74122/bank_card_cn_query'
```

And then execute:

    $ bundle

## Install

    $ rails generate bank_card_cn_query:install
adjust /config/initializers/bank_card_cn_query.rb

## Usage

- Check China Bank Card Info
```ruby
BankCardCnQuery::Check.new.check_bank_info(card_number)
```
