# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        class InvestmentAccount < ::Aranha::Parsers::Ofx::Data::Account
          attr_accessor :broker_id, :positions, :margin_balance, :short_balance, :cash_balance

          include ::Aranha::Parsers::Ofx::Data::MonetarySupport
          extend ::Aranha::Parsers::Ofx::Data::MonetaryClassSupport

          monetary_vars :margin_balance, :short_balance, :cash_balance
        end
      end
    end
  end
end
