# frozen_string_literal: true

# PortfolioStock model that represents a relationship between a stock and a percentage of the portfolio.
# Also stores the shares of the stock in the portfolio.
class PortfolioStock
  attr_reader :stock, :percentage, :shares

  def initialize(stock, percentage)
    @stock = stock
    @percentage = percentage
    @shares = 0
  end

  def buy(amount)
    @shares += amount / @stock.price
  end

  def sell(amount)
    @shares -= amount / @stock.price
  end

  def value
    @shares * @stock.price
  end
end
