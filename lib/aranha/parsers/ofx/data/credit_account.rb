# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        class CreditAccount < ::Aranha::Parsers::Ofx::Data::Account
          attr_accessor :remaining_credit, :remaining_credit_date, :balance, :balance_date

          include ::Aranha::Parsers::Ofx::Data::MonetarySupport
          extend ::Aranha::Parsers::Ofx::Data::MonetaryClassSupport

          monetary_vars :remaining_credit, :balance
        end
      end
    end
  end
end
