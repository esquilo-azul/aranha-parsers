# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        # Status of a sign on
        class Status
          attr_accessor :code, :severity, :message

          CODES = {
            '0' => 'Success',
            '2000' => 'General error',
            '15000' => 'Must change USERPASS',
            '15500' => 'Signon invalid',
            '15501' => 'Customer account already in use',
            '15502' => 'USERPASS Lockout'
          }.freeze

          def code_desc
            CODES[code]
          end

          undef code
          def code # rubocop:disable Lint/DuplicateMethods
            @code.to_s.strip
          end
        end
      end
    end
  end
end
