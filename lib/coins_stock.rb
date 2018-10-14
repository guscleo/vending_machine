# frozen_string_literal: true

require_relative 'coins'
require_relative 'change_calculator'

class CoinsStock
  NoCoinToRemove = Class.new(StandardError)

  def initialize(coins)
    @stock = Coins::TYPES.each_with_object({}) do |type, hash|
      hash[type] = coins[type] || 0
    end
  end

  def reload(coins)
    coins.each do |coin_type, qty|
      stock[coin_type] += qty
    end
  end

  def insert(coin_type)
    stock[coin_type] += 1
  end

  def remove(coins)
    coins.each do |coin_type, qty|
      raise NoCoinToRemove if qty > stock[coin_type]

      stock[coin_type] -= qty
    end
  end

  def change_for(change_needed)
    change = ChangeCalculator.calculate(stock, change_needed)

    change_amount = change.each.map { |coin_type, qty| Coins::VALUES[coin_type] * qty }.reduce(Money.new(0), :+)
    raise NoChange if change_amount < change_needed

    change
  end

  attr_reader :stock
end
