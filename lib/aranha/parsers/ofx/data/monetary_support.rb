# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        module MonetarySupport
          # Returns pennies for a given string amount, i.e:
          #  '-123.45' => -12345
          #  '123' => 12300
          def pennies_for(amount)
            return nil if amount == ''

            int, fraction = amount.scan(/\d+/)
            i = fraction.to_s.strip =~ /[1-9]/ ? "#{int}#{fraction[0, 2]}".to_i : int.to_i * 100
            amount =~ /^\s*-\s*\d+/ ? -i : i
          end

          def original_method(meth) # :nodoc:
            meth.to_s.sub('_in_pennies', '').to_sym
          rescue StandardError
            nil
          end

          def monetary_method_call?(meth) # :nodoc:
            orig = original_method(meth)
            self.class.monies.include?(orig) && meth.to_s == "#{orig}_in_pennies"
          end

          def method_missing(meth, *args) # :nodoc: # rubocop:disable Style/MissingRespondToMissing
            if monetary_method_call?(meth)
              pennies_for(send(original_method(meth)))
            else
              super
            end
          end

          def respond_to?(meth) # :nodoc:
            monetary_method_call?(meth) || super
          end
        end
      end
    end
  end
end
