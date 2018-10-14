# frozen_string_literal: true

# This file is not supposed to be really nice structured, but instead to provide just a quick way to test a possible app
require 'highline'

require 'money'
Money.default_currency = Money::Currency.new('GBP')
Money.locale_backend = :i18n
I18n.config.available_locales = :en

require_relative 'lib/vending_machine'
require_relative 'lib/session'

coins = {
  Coins::ONE_PENCE => 50,
  Coins::TWO_PENCES => 50,
  Coins::TWENTY_PENCES => 50
}

products = {
  '001' => { qty: 5, price: Money.new(90) },
  '002' => { qty: 10, price: Money.new(50) },
  '003' => { qty: 0, price: Money.new(50) }
}

vending_machine = VendingMachine.new(coins: coins, products: products)

def print_session(session)
  puts ''
  puts 'CURRENT SESSION'
  session.status.each do |key, value|
    puts "#{key}: #{value}"
  end
  puts ''
end

def print_machine(vending_machine)
  puts ''
  puts 'VENDING MACHINE - Coins stock'
  vending_machine.coins_stock.stock.each do |key, value|
    puts "#{key}: #{value}"
  end
  puts ''
end

def product_selected(session, product_code)
  session.select_product(product_code)
  print_session(session)
  loop do
    cli = HighLine.new
    cli.choose do |menu|
      Coins::TYPES.each do |coin_type|
        menu.choice(coin_type) do
          session.insert_coin(coin_type)
          print_session(session)
          return if session.status[:finished]
        end
      end
      menu.choice(:cancel, "Cancel") { return }
    end
  end
end

cli = HighLine.new
loop do
  print_machine(vending_machine)
  session = Session.new(vending_machine: vending_machine)

  cli.choose do |menu|
    menu.prompt = 'Select product: '

    vending_machine.products_stock.stock.each do |product_code, product|
      menu.choice("#{product_code} - #{product[:qty]} – #{product[:price]}") do
        product_selected(vending_machine, session, product_code)
      end
    end
    menu.choice(:quit, 'Exit program.') { exit }
  end
end
