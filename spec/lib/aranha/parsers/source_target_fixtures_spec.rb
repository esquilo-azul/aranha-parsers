# frozen_string_literal: true

require 'aranha/parsers/source_target_fixtures'

RSpec.describe ::Aranha::Parsers::SourceTargetFixtures do
  let(:fixtures_dir) { ::File.join(__dir__, 'source_target_fixtures_spec_files') }
  let(:instance) { described_class.new(fixtures_dir) }

  describe '#source_target_files' do
    it { expect(instance.source_target_files.count).to eq(3) }

    (1..3).each do |index|
      basename = "stub#{index}"
      let(basename) { instance.source_target_files.find { |stf| stf.basename == basename } }

      it { expect(send(basename)).to be_present }
      it { expect(send(basename).basename).to eq(basename) }
    end

    it { expect(stub1.source).to eq(::File.join(fixtures_dir, 'stub1.source.txt')) }
    it { expect(stub1.target).to eq(::File.join(fixtures_dir, 'stub1.target.html')) }
    it { expect(stub2.source).to eq(::File.join(fixtures_dir, 'stub2.source.html')) }
    it { expect(stub2.target).to eq(nil) }
    it { expect(stub3.source).to eq(nil) }
    it { expect(stub3.target).to eq(::File.join(fixtures_dir, 'stub3.target.yaml')) }
  end
end
