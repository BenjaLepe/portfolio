# frozen_string_literal: true

require_relative 'portfolio_stock'

# Portfolio model that manages a collection of PortfolioStock objects
class Portfolio
  attr_reader :portfolio_stocks

  # @param portfolio_stocks [Array] An array of PortfolioStock objects
  def initialize(portfolio_stocks)
    @portfolio_stocks = portfolio_stocks
    raise 'Invalid portfolio stocks' unless valid_portfolio_stocks?
  end

  # Add funds to the portfolio, distribute the amount proportionally to the stocks
  # @param amount [Float] The amount of funds to add
  def deposit(amount)
    @portfolio_stocks.each do |stock|
      stock.buy(amount * stock.percentage)
    end
  end

  # Get the operations to rebalance the portfolio
  # @return [Array] An array of operations to rebalance the portfolio
  def rebalance_operations
    current_portfolio_value = total_value
    operations = []

    @portfolio_stocks.each do |stock|
      operation = get_rebalance_operation(current_portfolio_value, stock)
      operations << operation if operation
    end

    operations
  end

  # Rebalance the portfolio by executing the operations
  # @param operations [Array] An array of operations to rebalance the portfolio
  def rebalance_portfolio(operations)
    operations.each do |operation|
      target_stock = @portfolio_stocks.find { |portfolio_stock| portfolio_stock.stock.code == operation[:stock] }
      if operation[:type] == :buy
        target_stock.buy(operation[:amount])
      else
        target_stock.sell(operation[:amount])
      end
    end
  end

  private

  def valid_portfolio_stocks?
    @portfolio_stocks.sum(&:percentage) == 1
  end

  def get_rebalance_operation(current_portfolio_value, portfolio_stock)
    expected_stock_value = current_portfolio_value * portfolio_stock.percentage
    difference = expected_stock_value - portfolio_stock.value

    if difference.positive?
      { stock: portfolio_stock.stock.code, amount: difference, type: :buy }
    elsif difference.negative?
      { stock: portfolio_stock.stock.code, amount: difference.abs, type: :sell }
    end
  end

  def total_value
    @portfolio_stocks.sum(&:value)
  end
end
