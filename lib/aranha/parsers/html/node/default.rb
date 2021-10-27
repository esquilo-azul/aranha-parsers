# frozen_string_literal: true

require 'aranha/parsers/html/node/base'
require 'eac_ruby_utils/core_ext'

module Aranha
  module Parsers
    module Html
      module Node
        class Default < ::Aranha::Parsers::Html::Node::Base
          require_sub __FILE__, include_modules: true

          def array_value(node, xpath)
            r = node.xpath(xpath).map { |n| n.text.strip }
            r.join('|')
          end

          def join_value(node, xpath)
            m = ''
            node.xpath(xpath).each do |n|
              m << n.text.strip
            end
            m
          end

          def duration_value(node, xpath)
            m = /(\d+) m/.match(join_value(node, xpath))
            m ? m[1].to_i : nil
          end
        end
      end
    end
  end
end
