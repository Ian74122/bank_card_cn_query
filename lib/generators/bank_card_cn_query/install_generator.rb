# frozen_string_literal: true

require 'rails/generators/base'

module BankCardCnQuery
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)
    desc "Creates a bank_card_cn_query initializer and copy locale files to your application."

    def copy_initializer
      template "bank_card_cn_query.rb", "config/initializers/bank_card_cn_query.rb"
    end
  end
end
