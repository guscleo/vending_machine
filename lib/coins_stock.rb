# frozen_string_literal: true

require_relative 'coins'

class CoinsStock
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

  attr_reader :stock
end
