# frozen_string_literal: true

RSpec.describe Session do
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

  let(:vending_machine) { VendingMachine.new(coins: coins_stock_list, products: products_stock_list) }

  let(:product_code) { '002' }

  subject { described_class.new(vending_machine: vending_machine) }

  it 'has a valid status' do
    expect(subject.status).to eq(
      product_selected: nil,
      cost: nil,
      amount_needed: nil,
      amount_inserted: Money.new(0),
      product_returned: false,
      coins_returned: {},
      finished: false
    )
  end

  context 'once an item is selected' do
    before { subject.select_product(product_code) }

    it 'has a valid status' do
      expect(subject.status).to eq(
        product_selected: product_code,
        cost: Money.new(50),
        amount_needed: Money.new(50),
        amount_inserted: 0,
        product_returned: false,
        coins_returned: {},
        finished: false
      )
    end

    context 'and the appropriate amount of money is inserted' do
      it 'has a valid status' do
        subject.insert_coin(Coins::FIFTY_PENCES)

        expect(subject.status).to eq(
          product_selected: product_code,
          cost: Money.new(50),
          amount_needed: Money.new(0),
          amount_inserted: Money.new(50),
          product_returned: true,
          coins_returned: {},
          finished: true
        )
      end

      it 'adds the coin to the vending machine\'s coin stock' do
        expect { subject.insert_coin(Coins::FIFTY_PENCES) }
          .to(change { vending_machine.coins_stock.stock[Coins::FIFTY_PENCES] }.from(0).to(1))
      end

      it 'removes the product from the vending_machine' do
        expect { subject.insert_coin(Coins::FIFTY_PENCES) }
          .to(change { vending_machine.products_stock.stock[product_code][:qty] }.from(10).to(9))
      end
    end

    context 'and too much money is provided' do
      it 'returns change' do
        subject.insert_coin(Coins::ONE_POUND)

        expect(subject.status).to eq(
          product_selected: product_code,
          cost: Money.new(50),
          amount_needed: Money.new(0),
          amount_inserted: Money.new(100),
          product_returned: true,
          coins_returned: { Coins::TWENTY_PENCES => 2, Coins::TWO_PENCES => 5 },
          finished: true
        )
      end

      it 'adds the coin to the vending machine\'s coin stock' do
        expect { subject.insert_coin(Coins::ONE_POUND) }
          .to(change { vending_machine.coins_stock.stock[Coins::ONE_POUND] }.from(0).to(1))
      end
    end

    context 'and insufficient funds have been inserted' do
      before { subject.insert_coin(Coins::TWENTY_PENCES) }

      it 'asks for more money' do
        expect(subject.status).to eq(
          product_selected: product_code,
          cost: Money.new(50),
          amount_needed: Money.new(30),
          amount_inserted: Money.new(20),
          product_returned: false,
          coins_returned: {},
          finished: false
        )
      end
    end
  end
end
