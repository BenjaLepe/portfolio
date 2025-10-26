# frozen_string_literal: true

# Stock model that represents a stock with a code and a price
class Stock
  attr_reader :code, :price

  def initialize(code, initial_price)
    @code = code
    @price = initial_price
  end

  def current_price(latest_price)
    @price = latest_price
  end
end
