# frozen_string_literal: true

class ProductsStock
  NoProductToRemove = Class.new(StandardError)

  def initialize(products)
    @stock = products
  end

  def reload(products)
    products.each do |product_key, options|
      stock.fetch(product_key)[:qty] += options[:qty]
    end
  end

  def return_product(product_code)
    product = stock.fetch(product_code)
    raise NoProductToRemove unless product[:qty].positive?

    stock.fetch(product_code)[:qty] -= 1
  end

  attr_reader :stock
end
