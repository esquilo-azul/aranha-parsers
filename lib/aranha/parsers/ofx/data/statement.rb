# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        class Statement
          attr_accessor :currency, :transactions, :start_date, :end_date
        end
      end
    end
  end
end
