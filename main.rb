# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'models/portfolio'
require_relative 'models/stock'
require_relative 'models/portfolio_stock'

INITIAL_FUNDS = 1000
ALLOCATIONS = {
  'AAPL' => 0.5,
  'GOOG' => 0.3,
  'MSFT' => 0.2
}.freeze

# Portfolio tests suite
class PortfolioTest < Minitest::Test
  # Setup the portfolio with the initial stocks and allocations
  def setup
    @stock_aapl = Stock.new('AAPL', 150)
    @stock_goog = Stock.new('GOOG', 2800)
    @stock_msft = Stock.new('MSFT', 200)
    @portfolio = Portfolio.new([
      PortfolioStock.new(@stock_aapl, ALLOCATIONS['AAPL']),
      PortfolioStock.new(@stock_goog, ALLOCATIONS['GOOG']),
      PortfolioStock.new(@stock_msft, ALLOCATIONS['MSFT'])
    ])
    @portfolio.deposit(INITIAL_FUNDS)
  end

  # Test that the initial portfolio value is correct.
  def test_initial_portfolio_value_is_correct
    assert_equal INITIAL_FUNDS * ALLOCATIONS['AAPL'], @portfolio.portfolio_stocks[0].value
    assert_equal INITIAL_FUNDS * ALLOCATIONS['GOOG'], @portfolio.portfolio_stocks[1].value
    assert_equal INITIAL_FUNDS * ALLOCATIONS['MSFT'], @portfolio.portfolio_stocks[2].value
  end

  # Test that the rebalance operations are correct. This only tests the operations, not the portfolio rebalancing.
  def test_rebalance_operations_are_correct
    # Increment the price of the AAPL stock
    stock_aapl_increment = 100
    @stock_aapl.current_price(@stock_aapl.price + stock_aapl_increment)

    # Get the rebalance operations
    operations = @portfolio.rebalance_operations

    # Check that the operations types are correct
    assert_equal 3, operations.size
    assert_equal :sell, operations[0][:type]
    assert_equal 'AAPL', operations[0][:stock]
    assert_equal :buy, operations[1][:type]
    assert_equal 'GOOG', operations[1][:stock]
    assert_equal :buy, operations[2][:type]
    assert_equal 'MSFT', operations[2][:stock]

    # Check that the sum of the operations is 0 (no money is lost)
    sum_of_operations = 0
    operations.each do |operation|
      if operation[:type] == :buy
        sum_of_operations += operation[:amount]
      else
        sum_of_operations -= operation[:amount]
      end
    end

    assert_in_delta 0, sum_of_operations, 1e-4
  end

  # Test that the rebalance portfolio method works correctly. Stocks are bought and sold correctly.
  def test_rebalance_portfolio_is_correct
    # Increment the price of the AAPL stock
    stock_increment = 100
    @stock_aapl.current_price(@stock_aapl.price + stock_increment)

    # Get the new portfolio value
    new_portfolio_value = INITIAL_FUNDS + stock_increment * @portfolio.portfolio_stocks[0].shares

    # Check that the portfolio allocations are not correct
    refute_equal new_portfolio_value * ALLOCATIONS['AAPL'], @portfolio.portfolio_stocks[0].value
    refute_equal new_portfolio_value * ALLOCATIONS['GOOG'], @portfolio.portfolio_stocks[1].value
    refute_equal new_portfolio_value * ALLOCATIONS['MSFT'], @portfolio.portfolio_stocks[2].value

    # Get the rebalance operations
    operations = @portfolio.rebalance_operations
    @portfolio.rebalance_portfolio(operations)

    # Check that the portfolio allocations are correct
    assert_equal new_portfolio_value * ALLOCATIONS['AAPL'], @portfolio.portfolio_stocks[0].value
    assert_equal new_portfolio_value * ALLOCATIONS['GOOG'], @portfolio.portfolio_stocks[1].value
    assert_equal new_portfolio_value * ALLOCATIONS['MSFT'], @portfolio.portfolio_stocks[2].value
  end
end
