# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        module MonetaryClassSupport
          attr_accessor :monies

          def monetary_vars(*methods) # :nodoc:
            self.monies ||= []
            self.monies += methods
          end
        end
      end
    end
  end
end
