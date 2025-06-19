# frozen_string_literal: true

module Aranha
  module Parsers
    module Html
      class ItemList < Base
        def data
          items_data
        end

        def item_data(item)
          item
        end

        def items_data
          count = 0
          @data ||= nokogiri.xpath(items_xpath).map do |m|
            count += 1
            item_data(node_parser.parse(m))
          end
        rescue StandardError => e
          raise StandardError, "#{e.message} (Count: #{count})"
        end

        def items_xpath
          raise "Class #{self.class} has no method \"#{__method__}\". Implement it"
        end
      end
    end
  end
end
