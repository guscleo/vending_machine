# frozen_string_literal: true

class Session
  NoChange = Class.new(StandardError)
  OutOfStock = Class.new(StandardError)
  SessionFinished = Class.new(StandardError)

  def initialize(vending_machine:)
    @vending_machine = vending_machine
    @coins_inserted = []
    @coins_returned = {}
    @product_returned = false
    @finished = false
  end

  def select_product(product_code)
    raise SessionFinished if finished
    raise OutOfStock if out_of_stock?(product_code)

    @product_selected = product_code

    return_item_and_change_if_possible
  end

  def insert_coin(coin_type)
    raise SessionFinished if finished

    vending_machine.insert_coin(coin_type)
    coins_inserted.push(coin_type)

    return_item_and_change_if_possible
  end

  def status
    {
      product_selected: product_selected,
      cost: cost,
      amount_needed: amount_needed,
      amount_inserted: amount_inserted,
      product_returned: product_returned,
      coins_returned: coins_returned,
      finished: finished
    }
  end

  private

  def out_of_stock?(product_code)
    vending_machine.product_stock(product_code).zero?
  end

  def amount_needed
    return unless product_selected

    [cost - amount_inserted, Money.new(0)].max
  end

  def cost
    vending_machine.cost_for(product_selected)
  end

  def amount_inserted
    coins_inserted.map { |coin_type| Coins::VALUES[coin_type] }.reduce(0, :+)
  end

  def return_item_and_change_if_possible
    return unless amount_inserted >= cost

    return_change
    return_product

    @finished = true
  end

  def return_change
    change_needed = amount_inserted - cost

    change = vending_machine.change_for(change_needed)

    vending_machine.remove_coins(change)
    @coins_returned = change
  end

  def return_product
    vending_machine.return_product(product_selected)
    @product_returned = true
  end

  attr_reader :coins_inserted, :coins_returned, :finished, :product_returned, :product_selected, :vending_machine
end
