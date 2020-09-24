# frozen_string_literal: true

require 'open-uri'
require 'fileutils'
require 'aranha/parsers/source_address'
require 'eac_ruby_utils/fs/temp'

module Aranha
  module Parsers
    class Base
      class << self
        def from_content(content)
          ::EacRubyUtils::Fs::Temp.on_file do |path|
            path.write(content)
            r = new(path.to_path)
            r.content
            r
          end
        end

        def parse_content(content)
          from_content(content).data
        end
      end

      LOG_DIR_ENVVAR = 'ARANHA_PARSERS_LOG_DIR'

      attr_reader :source_address

      def initialize(url)
        @source_address = ::Aranha::Parsers::SourceAddress.new(url)
        log_content(source_address.serialize, '-source-address')
      end

      delegate :url, to: :source_address

      def content
        @content ||= begin
          s = source_address.content
          log_content(s)
          s
        end
      end

      private

      def log_content(content, suffix = '')
        path = log_file(suffix)

        return unless path

        File.open(path, 'wb') { |file| file.write(content) }
      end

      def log_file(suffix)
        dir = log_parsers_dir
        return nil unless dir

        f = ::File.join(dir, "#{self.class.name.parameterize}#{suffix}.log")
        FileUtils.mkdir_p(File.dirname(f))
        f
      end

      def log_parsers_dir
        return ENV[LOG_DIR_ENVVAR] if ENV[LOG_DIR_ENVVAR]
        return ::Rails.root.join('log', 'parsers') if rails_root_exist?

        nil
      end

      def rails_root_exist?
        ::Rails.root
        true
      rescue NameError
        false
      end
    end
  end
end
