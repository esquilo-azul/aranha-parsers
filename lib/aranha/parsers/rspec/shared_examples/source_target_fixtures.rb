# frozen_string_literal: true

require 'aranha/parsers/rspec/source_target_fixtures_controller'
require 'aranha/parsers/source_target_fixtures'
require 'yaml'

RSpec.shared_examples 'source_target_fixtures' do |spec_file| # rubocop:disable Metrics/BlockLength
  fixtures_controller = ::Aranha::Parsers::Rspec::SourceTargetFixturesController
                          .new(self, spec_file)

  let(:fixtures_controller) { fixtures_controller }
  let(:spec_file) { spec_file }

  it 'fixtures directory should exist' do
    expect(::File.directory?(fixtures_controller.fixtures_dir)).to be true
  end

  context 'with fixtures directory' do
    it 'has at least one file' do
      expect(source_target_fixtures.source_target_files.count).to be > 0 # rubocop:disable Style/NumericPredicate
    end

    fixtures_controller.source_target_fixtures.source_target_files.each do |st|
      context "when source file is \"#{::File.basename(st.source)}\"" do
        if fixtures_controller.write_target_fixtures?
          it 'writes target data' do
            sd = sort_results(source_data(st.source))
            basename = ::Aranha::Parsers::SourceTargetFixtures.source_target_basename(st.source)
            target_file = File.expand_path("../#{basename}.target#{target_file_extname}", st.source)
            File.write(target_file, target_content(sd))
          end
        else
          it 'parses data' do
            assert_source_target_complete(st)
            sd = source_data(st.source)
            td = target_data(st.target)
            expect(sort_results(sd)).to eq(sort_results(td))
          end
        end
      end
    end
  end

  delegate :source_target_fixtures, to: :fixtures_controller

  def assert_source_target_complete(source_target)
    expect(source_target.source).to(be_truthy, "Source not found (Target: #{source_target.target})")
    expect(source_target.target).to(be_truthy, "Target not found (Source: #{source_target.source})")
  end

  def source_data(source_file)
    instance = described_class.new(source_file)
    return instance.data if instance.respond_to?(:data)

    raise "#{instance} has no \"data\" method. You need to implement \"#{instance}.data\" or " \
          "\"#{self}.source_data(source_file)\""
  end

  def sort_results(results)
    results
  end

  def target_data(target_file)
    ::YAML.load_file(target_file)
  end

  def target_content(data)
    data.to_yaml
  end

  def target_file_extname
    '.yaml'
  end
end
