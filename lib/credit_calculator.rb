# Класс для выщитывание ежемесячных ориентировачных сум платежей по кредиту
class CreditCalculator
  attr_reader :global_sum, :global_percent_sum, :credit_sum, :percent_for_show

  def initialize(params)
    @percent = params['percent'].to_f
    @percent_for_show = round_num(@percent)
    @credit_sum = params['credit_sum'].to_f
    @pay_off = params['pay-off']
    @credit_time = params['term'].to_i
  end

  # выберает тип погашения кредита, взависимости от переданного параметра params['pay-off']
  def credit_off
    case @pay_off
      when 'Usual'
        standard_type_off
      when 'Equal'
        annuity_type_off
    end
  end

  # стандартный тип погашения кредита
  # берет параметры из конструктора, возвращает массив массивов со значениями за каждый месяц.
  # погашение кредита, погашение %, общий взнос, остаток кредита.
  def standard_type_off
    sums = [] #
    loan_repayment = (@credit_sum / @credit_time) # погашение кредита
    @global_percent_sum = 0 # сумма погашение % за весь период
    @global_sum = 0 # общий взнос за весь период

    @credit_time.times do |count|
      array = []
      credit_sum = (@credit_sum - loan_repayment * count) # остаток кредита
      amount_percent = (credit_sum * @percent / 12.to_f) / 100 # сумма погашение %
      sum_per_month = loan_repayment.round(2) + amount_percent.round(2) # общий взнос

      # остаток кредита с учётом взноса
      credit_sum2 = (@credit_sum - loan_repayment * (count + 1))

      # создаю новый массив со сзначениеми текущего месяца и запушиваю в sums
      array.push(round_num(loan_repayment), round_num(amount_percent),
                 round_num(sum_per_month), round_num(credit_sum2))

      sums.push(array)

      @global_percent_sum += amount_percent
      @global_sum += sum_per_month
    end

    # округляю значение
    @global_percent_sum = round_num(@global_percent_sum)
    @global_sum = round_num(@global_sum)
    @credit_sum = round_num(@credit_sum)
    sums
  end

  # метод для подсчета аннуитентного кредита
  # аналогично методу standard_type_off возвращает массив массивов со значениям:
  # погашение кредита, погашение %, общий взнос, остаток кредита.
  def annuity_type_off
    sums = [] # тут будут массивы значений за каждый месяц

    # процентная ставка выраженная в сотых долях в расчете на период
    p = @percent / 100 / 12
    n = @credit_time # кол-во месяцев

    # коэффициент аннуитета
    k = p * (1 + p)**n / ((1 + p)**n - 1)
    sum_per_month = (k * @credit_sum) # общий взнос
    @global_sum = round_num(sum_per_month * n) # общий взнос за весь период
    @global_percent_sum = 0 # сумма погашение в % за весь период

    credit_sum = @credit_sum

    @credit_time.times do
      array = []

      percent_sum = credit_sum * p # сумма погашение в %
      loan_repayment = sum_per_month - percent_sum # погашение кредита
      credit_sum -= loan_repayment # остаток кредита

      array.push(round_num(loan_repayment), round_num(percent_sum), round_num(sum_per_month),
                 round_num(credit_sum.abs))
      sums.push(array)
      @global_percent_sum += percent_sum
    end
    # округляю сведенья
    @global_percent_sum = round_num(@global_percent_sum)
    @credit_sum = round_num(@credit_sum)
    sums
  end

  private

  # добавляет к числу - 0, если оно не округленно до сотых и добавляет отступы,
  # для удобства
  def round_num(num)
    n = '%.2f' % num
    n.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, '\\1 ')
  end
end