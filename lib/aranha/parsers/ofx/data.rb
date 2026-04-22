# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      # This class is returned when a parse is successful.
      # == General Notes
      # * currency symbols are an iso4217 3-letter code
      # * language is defined by iso639 3-letter code
      class Data
        attr_accessor :header, :sign_on, :signup_account_info,
                      :bank_account, :credit_card, :investment

        def accounts
          accounts = []
          %i[bank_account credit_card investment].each do |method|
            val = send(method)
            accounts << val if val
          end
          accounts
        end
      end
    end
  end
end
