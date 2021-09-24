# frozen_string_literal: true

require "bank_card_cn_query/version"
require "rest-client"
require "rails"

module BankCardCnQuery
  autoload :Check, 'bank_card_cn_query/check'

  mattr_accessor :url
  @@url = nil

  mattr_accessor :secret_id
  @@secret_id = nil

  mattr_accessor :secret_key
  @@secret_key = nil

  mattr_accessor :source
  @@source = nil

  def self.setup
    yield self
  end
end
