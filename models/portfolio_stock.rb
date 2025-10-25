class PortfolioStock
  attr_reader :stock, :percentage, :quantity

  def initialize(stock, percentage)
    @stock = stock
    @percentage = percentage
    @quantity = 0
  end

  def deposit(amount)
    @quantity += amount
  end

  def withdraw(amount)
    @quantity -= amount
  end

  def value
    @quantity * @stock.price
  end

  def code
    @stock.code
  end

  def price
    @stock.price
  end
end
