# frozen_string_literal: true

class ProductsStock
  def initialize(products)
    @stock = products
  end

  def reload(products)
    products.each do |product_key, options|
      stock.fetch(product_key)[:qty] += options[:qty]
    end
  end

  attr_reader :stock
end
