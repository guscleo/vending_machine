# frozen_string_literal: true

class ChangeCalculator
  def self.calculate(*attrs)
    new(*attrs).calculate
  end

  def initialize(stock, change_needed)
    @change_needed = change_needed
    @stock = stock
  end

  def calculate
    return {} if change_needed.zero?

    change_left_to_give = change_needed
    sorted_coin_types.each_with_object({}) do |coin_type, change|
      while coin_type_fits?(coin_type, change_left_to_give, change)
        change_left_to_give -= Coins::VALUES[coin_type]
        change[coin_type] ||= 0
        change[coin_type] += 1
      end
    end
  end

  private

  def coin_type_fits?(coin_type, change_left_to_give, current_change)
    Coins::VALUES[coin_type] <= change_left_to_give && (stock[coin_type] - current_change.fetch(coin_type, 0)).positive?
  end

  def sorted_coin_types
    @sorted_coin_types ||= Coins::TYPES.sort_by { |coin_type| Coins::VALUES[coin_type] }.reverse
  end

  attr_reader :change_needed, :stock
end
