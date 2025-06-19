# frozen_string_literal: true

module Aranha
  module Parsers
    class SourceAddress
      class HashHttpBase
        class Headers
          acts_as_immutable
          immutable_accessor :value, type: :hash

          # @!method to_h()
          # @return [Hash]
          delegate :to_h, to: :values

          # @param other_values [Array, Hash]
          # @return [Aranha::Parsers::SourceAddress::HashHttpBase::Headers]
          def merge(other_values)
            if other_values.is_a?(::Hash)
              values(values.merge(other_values))
            elsif other_values.is_a?(::Enumerable)
              merge(other_values.to_h { |v| merge_array_item_to_h(v) })
            else
              raise ::ArgumentError,
                    "\"other_values\"=\"#{other_values}\" should be a Array or a Hash"
            end
          end

          private

          # @param item [Array]
          # @return [Array
          def merge_array_item_to_h(item)
            2.times.inject(Array(item)) do |a, e|
              e >= a.count ? a + [nil] : a
            end
          end
        end
      end
    end
  end
end
