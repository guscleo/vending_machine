# frozen_string_literal: true

RSpec.describe VendingMachine do
  let(:coins_stock_list) do
    {
      Coins::ONE_PENCE => 50,
      Coins::TWO_PENCES => 50,
      Coins::TWENTY_PENCES => 50
    }
  end

  let(:products_stock_list) do
    {
      '001' => { qty: 5, price: Money.new(90) },
      '002' => { qty: 10, price: Money.new(50) },
      '003' => { qty: 0, price: Money.new(50) }
    }
  end

  subject { described_class.new(coins: coins_stock_list, products: products_stock_list) }

  describe '#initialize' do
    it 'stores products' do
      expect(subject.products_stock.stock).to eq(products_stock_list)

      expect(subject.products_stock.stock['001']). to eq(qty: 5, price: Money.new(90))
    end

    it 'stores coins' do
      expect(subject.coins_stock.stock.keys.size).to eq(Coins::TYPES.size)

      expect(subject.coins_stock.stock[Coins::ONE_PENCE]).to eq(50)
      expect(subject.coins_stock.stock[Coins::ONE_POUND]).to eq(0)
    end
  end

  describe '#reload_products' do
    let(:new_products) do
      {
        '001' => { qty: 10 },
        '002' => { qty: 0 }
      }
    end

    it 'increases the quantity of product 001' do
      expect { subject.reload_products(products: new_products) }
        .to(change { subject.products_stock.stock['001'][:qty] }.from(5).to(15))
    end

    it 'does not increase the quantity of product 002' do
      expect { subject.reload_products(products: new_products) }.to_not(change { subject.products_stock.stock['002'] })
    end

    it 'does not increase the quantity of product 003' do
      expect { subject.reload_products(products: new_products) }.to_not(change { subject.products_stock.stock['003'] })
    end
  end

  describe '#reload_coins' do
    let(:new_coins) do
      {
        Coins::ONE_PENCE => 50,
        Coins::TWO_POUNDS => 0
      }
    end

    it 'increases the quantity of one pence coins' do
      expect { subject.reload_coins(coins: new_coins) }
        .to(change { subject.coins_stock.stock[Coins::ONE_PENCE] }.from(50).to(100))
    end

    it 'does not increase the quantity of two pounds coins' do
      expect { subject.reload_coins(coins: new_coins) }.to_not(change { subject.coins_stock.stock[Coins::TWO_POUNDS] })
    end

    it 'does not increase the quantity of one pound coins' do
      expect { subject.reload_coins(coins: new_coins) }.to_not(change { subject.coins_stock.stock[Coins::ONE_POUND] })
    end
  end

  context 'once an item is selected' do
    context 'and the appropriate amount of money is inserted' do
      xit 'returns the correct product' do
      end
    end

    context 'and too much money is provided' do
      xit 'returns change' do
      end
    end

    context 'and insufficient funds have been inserted' do
      xit 'asks for more money' do
      end
    end
  end
end
