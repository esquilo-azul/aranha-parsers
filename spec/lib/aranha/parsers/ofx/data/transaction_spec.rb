# frozen_string_literal: true

RSpec.describe(Aranha::Parsers::Ofx::Data::Transaction) do
  it 'monetary_support_call' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    t = described_class.new
    t.amount = '-11.1'

    expect { t.amount_in_pennies }.not_to raise_error
    expect { t.amount_in_whatever }.to raise_error(NoMethodError)

    expect(t).to respond_to(:amount_in_pennies)
    expect(t).not_to respond_to(:amount_in_whatever)
  end
end
