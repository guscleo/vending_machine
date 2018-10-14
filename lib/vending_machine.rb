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

  def insert_coin(coin_type)
    coins_stock.insert(coin_type)
  end

  def change_for(change_needed)
    coins_stock.change_for(change_needed)
  end

  def remove_coins(coins)
    coins_stock.remove(coins)
  end

  def reload_products(products:)
    products_stock.reload(products)
  end

  def cost_for(product_code)
    products_stock.stock.fetch(product_code, {})[:price]
  end

  def product_stock(product_code)
    products_stock.stock.fetch(product_code, {})[:qty] || 0
  end

  def return_product(product_code)
    products_stock.return_product(product_code)
  end

  attr_reader :coins_stock, :products_stock
end
