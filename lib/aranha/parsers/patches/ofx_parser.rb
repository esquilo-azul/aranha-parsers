# frozen_string_literal: true

require 'ofx-parser'

module Aranha
  module Parsers
    module Patches
      module OfxParser
        module OfxParser
          def self.included(base)
            base.class_eval do
              class << self
                prepend ClassMethods
              end
            end
          end

          module ClassMethods
            def build_transaction(transaction)
              r = super
              r.currate = (transaction / 'CURRENCY/CURRATE').inner_text
              r
            end
          end
        end

        module Transaction
          attr_accessor :currate, :cursym
        end
      end
    end
  end
end

EacRubyUtils.patch_module(OfxParser::OfxParser, Aranha::Parsers::Patches::OfxParser::OfxParser)
EacRubyUtils.patch_module(OfxParser::Transaction, Aranha::Parsers::Patches::OfxParser::Transaction)
