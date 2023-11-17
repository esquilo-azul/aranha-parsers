# frozen_string_literal: true

RSpec.describe 'RSpec.shared_examples(\'source_target_fixtures\')' do # rubocop:disable RSpec/DescribeClass
  include_examples 'source_target_fixtures', __FILE__

  def source_data(source_file)
    File.read(source_file)
  end
end
