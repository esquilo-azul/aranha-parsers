# frozen_string_literal: true

require 'aranha/parsers/source_target_fixtures'
require 'yaml'

RSpec.shared_examples 'source_target_fixtures' do |spec_file| # rubocop:disable Metrics/BlockLength
  let(:spec_file) { spec_file }

  it 'fixtures directory should exist' do
    expect(::File.directory?(fixtures_dir)).to be true
  end

  context 'with fixtures directory' do
    it 'has at least one file' do
      expect(source_target_fixtures.source_target_files.count).to be > 0 # rubocop:disable Style/NumericPredicate
    end

    if ENV['WRITE_TARGET_FIXTURES']
      it 'writes target data for all files' do
        source_target_fixtures.source_files.each do |source_file|
          sd = sort_results(source_data(source_file))
          basename = ::Aranha::Parsers::SourceTargetFixtures.source_target_basename(source_file)
          target_file = File.expand_path("../#{basename}.target.yaml", source_file)
          File.write(target_file, sd.to_yaml)
        end
      end
    else
      it 'parses data for all files' do
        source_target_fixtures.source_target_files.each do |st|
          assert_source_target_complete(st)
          sd = source_data(st.source)
          td = target_data(st.target)
          expect(sort_results(sd)).to eq(sort_results(td))
        end
      end
    end
  end

  def source_target_fixtures
    @source_target_fixtures ||= ::Aranha::Parsers::SourceTargetFixtures.new(fixtures_dir)
  end

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

  def fixtures_dir
    ::File.join(
      ::File.dirname(spec_file),
      ::File.basename(spec_file, '.*') + '_files'
    )
  end

  def sort_results(results)
    results
  end

  def target_data(target_file)
    ::YAML.load_file(target_file)
  end
end
