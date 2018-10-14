# frozen_string_literal: true

module Coins
  ONE_PENCE = '1p'
  TWO_PENCES = '2p'
  FIVE_PENCES = '5p'
  TEN_PENCES = '10p'
  TWENTY_PENCES = '20p'
  FIFTY_PENCES = '50p'
  ONE_POUND = '£1'
  TWO_POUNDS = '£2'

  TYPES = [ONE_PENCE, TWO_PENCES, FIVE_PENCES, TEN_PENCES, TWENTY_PENCES, FIFTY_PENCES, ONE_POUND, TWO_POUNDS].freeze

  VALUES = {
    ONE_PENCE => Money.new(1),
    TWO_PENCES => Money.new(2),
    FIVE_PENCES => Money.new(5),
    TEN_PENCES => Money.new(10),
    TWENTY_PENCES => Money.new(20),
    FIFTY_PENCES => Money.new(50),
    ONE_POUND => Money.new(100),
    TWO_POUNDS => Money.new(200)
  }.freeze
end
