# frozen_string_literal: true

RSpec.describe Aranha::Parsers::Ofx::Parser do
  include_context 'spec_paths', __FILE__

  let(:ofx_files) do
    r = {}
    Dir.open(fixtures_directory.to_path).each do |fn|
      next unless fn =~ /\.ofx\.sgml$/

      ofx = File.read(fixtures_directory.to_path + "/#{fn}")
      ofx.gsub!(/\r?\n/, "\r\n") # change line endings to \r\n

      r[fn.scan(/\w+/).first.to_sym] = ofx
    end
    r
  end

  it 'pre_process header' do
    header, = described_class.pre_process(ofx_files[:with_spaces])

    expect(header.keys.size).to eq(9)
  end

  it 'parse_datetime' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    expect(described_class.parse_datetime('20070622190000.200[-5:CDT]')).to eq(
      DateTime.civil(2007, 6, 22, 19, 0, 0, Rational(-5, 24))
    )
    expect(described_class.parse_datetime('20070622190000.200[+9.0:JST]')).to eq(
      DateTime.civil(2007, 6, 22, 19, 0, 0, Rational(9, 24))
    )
    expect(described_class.parse_datetime('20070622')).to eq(DateTime.civil(2007, 6, 22))
    expect(described_class.parse_datetime('20070622190000')).to eq(
      DateTime.civil(2007, 6, 22, 19, 0, 0)
    )
    expect(described_class.parse_datetime('20070622190000.200')).to eq(
      DateTime.civil(2007, 6, 22, 19, 0, 0)
    )
  end

  it 'sign_on' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    ofx = described_class.parse(ofx_files[:with_spaces])

    expect(ofx.sign_on.status.code).to eq('0')
    expect(ofx.sign_on.status.severity).to eq('INFO')
    expect(ofx.sign_on.status.message).to eq('The user is authentic; operation succeeded.')
    expect(ofx.sign_on.status.code_desc).to eq('Success')

    expect(ofx.sign_on.date).to eq(DateTime.civil(2007, 6, 23, 14, 26, 35, Rational(-5, 24)))
    expect(ofx.sign_on.language).to eq('ENG')
    expect(ofx.sign_on.institute.name).to eq('U.S. Bank')
    expect(ofx.sign_on.institute.id).to eq('1402')
  end

  it 'no_accounts' do
    ofx = described_class.parse(ofx_files[:with_spaces])

    expect(ofx.accounts.size).to eq(0)
  end

  it 'banking' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    ofx = described_class.parse(ofx_files[:banking])

    acct = ofx.bank_account

    expect(acct.number).to eq('103333333333')
    expect(acct.routing_number).to eq('033000033')
    expect(acct.type).to eq(:CHECKING)
    expect(acct.balance).to eq('1234.09')
    expect(acct.balance_in_pennies).to eq(123_409)
    expect(acct.balance_date).to eq(DateTime.civil(2007, 6, 23, 14, 26, 35, Rational(-5, 24)))
    expect(acct.transaction_uid).to eq('9C24229A0077EAA50000011353C9E00743FC')

    statement = acct.statement

    expect(statement.currency).to eq('USD')
    expect(statement.start_date).to eq(DateTime.civil(2007, 6, 4, 19, 0, 0, Rational(-5, 24)))
    expect(statement.end_date).to eq(DateTime.civil(2007, 6, 22, 19, 0, 0, Rational(-5, 24)))

    transactions = statement.transactions
    expect(transactions.size).to eq(4)

    expect(transactions[0].type).to eq(:PAYMENT)
    expect(transactions[0].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:PAYMENT])
    expect(transactions[0].date).to eq(DateTime.civil(2007, 6, 6, 12, 0, 0))
    expect(transactions[0].amount).to eq('-11.11')
    expect(transactions[0].amount_in_pennies).to eq(-1111)
    expect(transactions[0].fit_id).to eq('11111111 22')
    expect(transactions[0].check_number).to be_nil
    expect(transactions[0].sic).to be_nil
    expect(transactions[0].sic_desc).to be_nil
    expect(transactions[0].payee).to eq('WEB AUTHORIZED PMT FOO INC')
    expect(transactions[0].memo).to eq('Download from usbank.com. FOO INC')

    expect(transactions[1].type).to eq(:CHECK)
    expect(transactions[1].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:CHECK])
    expect(transactions[1].date).to eq(DateTime.civil(2007, 6, 7, 12, 0, 0))
    expect(transactions[1].amount).to eq('-111.11')
    expect(transactions[1].amount_in_pennies).to eq(-11_111)
    expect(transactions[1].fit_id).to eq('22222A')
    expect(transactions[1].check_number).to eq('0000009611')
    expect(transactions[1].sic).to be_nil
    expect(transactions[1].sic_desc).to be_nil
    expect(transactions[1].payee).to eq('CHECK')
    expect(transactions[1].memo).to eq('Download from usbank.com.')

    expect(transactions[2].type).to eq(:DIRECTDEP)
    expect(transactions[2].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:DIRECTDEP])
    expect(transactions[2].date).to eq(DateTime.civil(2007, 6, 14, 12, 0, 0))
    expect(transactions[2].amount).to eq('1111.11')
    expect(transactions[2].amount_in_pennies).to eq(111_111)
    expect(transactions[2].fit_id).to eq('X34AE33')
    expect(transactions[2].check_number).to be_nil
    expect(transactions[2].sic).to be_nil
    expect(transactions[2].sic_desc).to be_nil
    expect(transactions[2].payee).to eq('ELECTRONIC DEPOSIT BAR INC')
    expect(transactions[2].memo).to eq('Download from usbank.com. BAR INC')

    expect(transactions[3].type).to eq(:CREDIT)
    expect(transactions[3].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:CREDIT])
    expect(transactions[3].date).to eq(DateTime.civil(2007, 6, 19, 12, 0, 0))
    expect(transactions[3].amount).to eq('11.11')
    expect(transactions[3].amount_in_pennies).to eq(1111)
    expect(transactions[3].fit_id).to eq('8 8 9089743')
    expect(transactions[3].check_number).to be_nil
    expect(transactions[3].sic).to be_nil
    expect(transactions[3].sic_desc).to be_nil
    expect(transactions[3].payee).to eq('ATM DEPOSIT US BANK ANYTOWNAS')
    expect(transactions[3].memo).to eq('Download from usbank.com. US BANK ANYTOWN ASUS1')

    expect(ofx.accounts.size).to eq(1)
  end

  it 'creditcard' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    ofx = described_class.parse(ofx_files[:creditcard])

    acct = ofx.credit_card

    expect(acct.number).to eq('XXXXXXXXXXXX1111')
    expect(acct.remaining_credit).to eq('19000.99')
    expect(acct.remaining_credit_in_pennies).to eq(1_900_099)
    expect(acct.remaining_credit_date).to eq(DateTime.civil(2007, 6, 23, 19, 20, 13))
    expect(acct.balance).to eq('-1111.01')
    expect(acct.balance_in_pennies).to eq(-111_101)
    expect(acct.balance_date).to eq(DateTime.civil(2007, 6, 23, 19, 20, 13))
    expect(acct.transaction_uid).to eq('0')

    statement = acct.statement

    expect(statement.currency).to eq('USD')
    expect(statement.start_date).to eq(DateTime.civil(2007, 5, 9, 12, 0, 0))
    expect(statement.end_date).to eq(DateTime.civil(2007, 6, 8, 12, 0, 0))

    transactions = statement.transactions
    expect(transactions.size).to eq(3)

    expect(transactions[0].type).to eq(:DEBIT)
    expect(transactions[0].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:DEBIT])
    expect(transactions[0].date).to eq(DateTime.civil(2007, 5, 10, 17, 0, 0))
    expect(transactions[0].amount).to eq('-19.17')
    expect(transactions[0].amount_in_pennies).to eq(-1917)
    expect(transactions[0].fit_id).to eq('xx')
    expect(transactions[0].check_number).to be_nil
    expect(transactions[0].sic).to eq('5912')
    expect(transactions[0].sic_desc).to eq(Aranha::Parsers::Ofx::Mcc::CODES['5912'])
    expect(transactions[0].payee).to eq('WALGREEN      34638675 ANYTOWN')
    expect(transactions[0].memo).to eq('')

    expect(transactions[1].type).to eq(:DEBIT)
    expect(transactions[1].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:DEBIT])
    expect(transactions[1].date).to eq(DateTime.civil(2007, 5, 12, 17, 0, 0))
    expect(transactions[1].amount).to eq('-12.0')
    expect(transactions[1].amount_in_pennies).to eq(-1200)
    expect(transactions[1].fit_id).to eq('yy-56')
    expect(transactions[1].check_number).to be_nil
    expect(transactions[1].sic).to eq('7933')
    expect(transactions[1].sic_desc).to eq(Aranha::Parsers::Ofx::Mcc::CODES['7933'])
    expect(transactions[1].payee).to eq('SUNSET BOWL            ANYTOWN')
    expect(transactions[1].memo).to eq('')

    expect(transactions[2].type).to eq(:CREDIT)
    expect(transactions[2].type_desc).to eq(Aranha::Parsers::Ofx::Data::Transaction::TYPE[:CREDIT])
    expect(transactions[2].date).to eq(DateTime.civil(2007, 5, 26, 17, 0, 0))
    expect(transactions[2].amount).to eq('11.01')
    expect(transactions[2].amount_in_pennies).to eq(1101)
    expect(transactions[2].fit_id).to eq('78-9')
    expect(transactions[2].check_number).to be_nil
    expect(transactions[2].sic).to eq('0000')
    expect(transactions[2].sic_desc).to be_nil
    expect(transactions[2].payee).to eq('ELECTRONIC PAYMENT-THANK YOU')
    expect(transactions[2].memo).to eq('')

    expect(ofx.accounts.size).to eq(1)
    expect(ofx.signup_account_info).to eq([])
  end

  it 'account_listing' do # rubocop:disable RSpec/MultipleExpectations
    ofx = described_class.parse(ofx_files[:list])

    cc_info = ofx.signup_account_info.first
    expect(cc_info.desc).to eq('CREDIT CARD ************1111')
    expect(cc_info.number).to eq('XXXXXXXXXXXX1111')

    expect(ofx.accounts.size).to eq(0)
  end

  it 'malformed_header_parses' do
    expect do
      described_class.parse(ofx_files[:malformed_header])
    end.not_to raise_error
  end
end
