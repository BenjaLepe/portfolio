require_relative 'portfolio_stock'

class Portfolio
  attr_reader :stocks

  # @param stocks [Array] An array of PortfolioStock objects
  def initialize(stocks)
    @stocks = stocks
    raise 'Invalid stocks' unless valid_stocks?
  end

  # Add funds to the portfolio, distribute the amount proportionally to the stocks
  # @param amount [Float] The amount of funds to add
  def deposit(amount)
    @stocks.each do |stock|
      stock.deposit(amount * stock.percentage / stock.price)
    end
  end

  # Rebalance the portfolio
  # @return [Array] An array of operations to rebalance the portfolio
  def rebalance_portfolio
    current_portfolio_value = total_value
    result = []

    @stocks.each do |stock|
      operation = get_rebalance_operation(current_portfolio_value, stock)
      result << operation if operation
    end
    result
  end

  private

  def valid_stocks?
    @stocks.sum(&:percentage) == 1
  end

  def get_rebalance_operation(current_portfolio_value, stock)
    expected_stock_value = current_portfolio_value * stock.percentage
    difference = expected_stock_value - stock.value

    if difference.positive?
      { stock: stock.code, amount: difference, type: :buy }
    elsif difference.negative?
      { stock: stock.code, amount: difference.abs, type: :sell }
    end
  end

  def total_value
    @stocks.sum { |stock| stock.quantity * stock.price }
  end
end
