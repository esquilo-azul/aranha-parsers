# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        class BankAccount < ::Aranha::Parsers::Ofx::Data::Account
          TYPE = %i[CHECKING SAVINGS MONEYMRKT CREDITLINE].freeze
          attr_accessor :type, :balance, :balance_date

          include ::Aranha::Parsers::Ofx::Data::MonetarySupport
          extend ::Aranha::Parsers::Ofx::Data::MonetaryClassSupport

          monetary_vars :balance

          undef type
          def type # rubocop:disable Lint/DuplicateMethods
            @type.to_s.upcase.to_sym
          end
        end
      end
    end
  end
end
