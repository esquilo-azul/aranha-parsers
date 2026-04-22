# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        class Account
          attr_accessor :number, :statement, :transaction_uid, :routing_number
        end
      end
    end
  end
end
