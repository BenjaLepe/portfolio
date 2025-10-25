require 'minitest/autorun'
require_relative 'models/portfolio'
require_relative 'models/stock'
require_relative 'models/portfolio_stock'

class PortfolioTest < Minitest::Test
  def setup
    @stock_aapl = Stock.new('AAPL', 150)
    @stock_goog = Stock.new('GOOG', 2800)
    @stock_msft = Stock.new('MSFT', 200)
    @portfolio = Portfolio.new([
      PortfolioStock.new(@stock_aapl, 0.5),
      PortfolioStock.new(@stock_goog, 0.3),
      PortfolioStock.new(@stock_msft, 0.2)
    ])
    @portfolio.deposit(1000)
  end

  def test_deposit_increases_cash
    assert_equal 1000.0 * 0.5, @portfolio.stocks[0].value
    assert_equal 1000.0 * 0.3, @portfolio.stocks[1].value
    assert_equal 1000.0 * 0.2, @portfolio.stocks[2].value
  end

  def test_rebalance_portfolio
    stock_aapl_increment = 100
    @stock_aapl.current_price(@stock_aapl.price + stock_aapl_increment)
    operations = @portfolio.rebalance_portfolio

    assert_equal 3, operations.size
    assert_equal :sell, operations[0][:type]
    assert_equal 'AAPL', operations[0][:stock]
    assert_equal :buy, operations[1][:type]
    assert_equal 'GOOG', operations[1][:stock]
    assert_equal :buy, operations[2][:type]
    assert_equal 'MSFT', operations[2][:stock]

    sum_of_operations = 0
    operations.each do |operation|
      if operation[:type] == :buy
        sum_of_operations += operation[:amount]
      else
        sum_of_operations -= operation[:amount]
      end
    end

    assert_in_delta 0, sum_of_operations, 1e-6
  end
end
