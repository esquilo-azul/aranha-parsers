# frozen_string_literal: true

RSpec.describe(Aranha::Parsers::Ofx::Data::MonetarySupport) do
  class X # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
    include Aranha::Parsers::Ofx::Data::MonetarySupport
    extend Aranha::Parsers::Ofx::Data::MonetaryClassSupport

    attr_accessor :amount

    monetary_vars :amount
  end

  it 'original_method' do # rubocop:disable RSpec/MultipleExpectations
    x = X.new
    expect(x.original_method('a_b_in_pennies')).to eq(:a_b)
    expect(x.original_method('a_in_pennies')).to eq(:a)
  end

  it 'for_pennies' do # rubocop:disable RSpec/ExampleLength
    amounts = {
      '-11.1' => -111,
      '-11.110' => -1111,
      '-11.11101' => -1111,
      '11.11' => 1111,
      '11,11' => 1111,
      '1' => 100,
      '1.0' => 100,
      '-1.0' => -100,
      '' => nil
    }

    x = X.new

    amounts.each do |actual, expected|
      x.amount = actual
      expect(x.amount_in_pennies).to eq(expected),
                                     "#{actual.inspect} should give #{expected.inspect}"
    end
  end
end
