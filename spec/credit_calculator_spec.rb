require 'rspec'
require_relative '../lib/credit_calculator'

# проверка класса CreditCalculator
describe 'CreditCalculator' do

  let(:params) {{'percent' => 20, 'credit_sum' => 1000, 'term' => 12}}
  let(:credit_calculator) {CreditCalculator.new(params)}

  it 'standard_type_off' do
    array_result = credit_calculator.standard_type_off
    array_result.each {|arr| arr.map!(&:to_f)} # перевожу все значения вложенных массивов в Float

    expect(array_result.size).to eq 12

    # сумма погашения кредита, каждый месяц эквивалентна
    loan_repayment = (params['credit_sum'].to_f / params['term']).round(2)

    # проверяю сумму погашения кредита, за каждый месяц
    array_result.each {|sum| expect(sum[0]).to eq loan_repayment}

    # проверяю, что сумма погашения кредита + сумма погашение % = общему взносу
    array_result.each do |sum|
      expect(sum[0] + sum[1]).to eq sum[2]
    end

    # проверяю, что остаток кредита после выплат = 0
    expect(array_result.last.last).to eq 0
  end

  it 'annuity_type_off' do
    array_result = credit_calculator.annuity_type_off
    array_result.each {|arr| arr.map!(&:to_f)}

    expect(array_result.size).to eq 12

    # проверяю, что общий взнос за каждый месяц эквивалентен
    sum_per_month = array_result[0][2]
    array_result.each {|sum| expect(sum[2]).to eq sum_per_month}

    # проверяю, что остаток кредита после выплат = 0
    expect(array_result.last.last).to eq 0
  end

  it 'credit_off' do
    # проверяю, если тип кредита стандартный, то вернет standart_credit_off
    params['pay-off'] = 'Usual'
    credit_calculator = CreditCalculator.new(params)
    credit_calculator2 = CreditCalculator.new(params)
    expect(credit_calculator.credit_off).to eq credit_calculator2.standard_type_off

    # проверяю, если тип кредита Аннуитентный (равными частями), то вернет annuity_credit_off
    params['pay-off'] = 'Equal'
    credit_calculator = CreditCalculator.new(params)
    credit_calculator2 = CreditCalculator.new(params)
    expect(credit_calculator.credit_off).to eq credit_calculator2.annuity_type_off

    # проверяю, что если в тип кредита передать ерунду, то вернет nil
    params['pay-off'] = 'trololo'
    credit_calculator = CreditCalculator.new(params)
    expect(credit_calculator.credit_off).to eq nil
  end

  it 'round_num' do
    num = 999999999999999999999999
    expect(credit_calculator.round_num(num)).to eq '999 999 999 999 999 999 999 999.00'
  end
end