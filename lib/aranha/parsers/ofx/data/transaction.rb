# frozen_string_literal: true

module Aranha
  module Parsers
    module Ofx
      class Data
        class Transaction
          attr_accessor :type, :date, :amount, :fit_id, :check_number, :sic, :memo, :payee

          include ::Aranha::Parsers::Ofx::Data::MonetarySupport
          extend ::Aranha::Parsers::Ofx::Data::MonetaryClassSupport

          monetary_vars :amount

          TYPE = {
            CREDIT: 'Generic credit',
            DEBIT: 'Generic debit',
            INT: 'Interest earned or paid ',
            DIV: 'Dividend',
            FEE: 'FI fee',
            SRVCHG: 'Service charge',
            DEP: 'Deposit',
            ATM: 'ATM debit or credit',
            POS: 'Point of sale debit or credit ',
            XFER: 'Transfer',
            CHECK: 'Check',
            PAYMENT: 'Electronic payment',
            CASH: 'Cash withdrawal',
            DIRECTDEP: 'Direct deposit',
            DIRECTDEBIT: 'Merchant initiated debit',
            REPEATPMT: 'Repeating payment/standing order',
            OTHER: 'Other'
          }.freeze

          def type_desc
            TYPE[type]
          end

          undef type
          def type # rubocop:disable Lint/DuplicateMethods
            @type.to_s.strip.upcase.to_sym
          end

          undef sic
          def sic # rubocop:disable Lint/DuplicateMethods
            @sic == '' ? nil : @sic
          end

          def sic_desc
            ::Aranha::Parsers::Ofx::Mcc::CODES[sic]
          end
        end
      end
    end
  end
end
