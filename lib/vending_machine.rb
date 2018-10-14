# frozen_string_literal: true

require 'money'
require_relative 'coins_stock'
require_relative 'products_stock'

class VendingMachine
  def initialize(coins: {}, products: {})
    @coins_stock = CoinsStock.new(coins)
    @products_stock = ProductsStock.new(products)
  end

  def reload_coins(coins:)
    coins_stock.reload(coins)
  end

  def reload_products(products:)
    products_stock.reload(products)
  end

  attr_reader :coins_stock, :products_stock
end
