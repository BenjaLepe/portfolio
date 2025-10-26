# Portfolio simulator 💸

This is a simple portfolio simulator that allows you to simulate a portfolio of stocks.

## Running the simulator (Local) 💻

You need to have ruby >= 3.0.0 installed.

```bash
bundle install
bundle exec ruby main.rb
```

## Running the simulator (Docker) 🐳

You need to have Docker installed and running.

```bash
docker build -t fintual-portfolio .
docker run --rm fintual-portfolio
```

## Notes 📝

I add some unit tests to show that the portfolio classes are working correctly. The tests are in `main.rb`.

There are three main classes:

- `Portfolio`: Manages the portfolio logic, including the funds deposit and the rebalance operations.
- `PortfolioStock`: Represents a relationship between a `Stock` and a percentage of the portfolio. It also stores the shares of the stock in the portfolio.
- `Stock`: Represents a stock with a code and a price. It also has a method to update the price of the stock.

I try to model the classes as a relational database. So `PortfolioStock` is like a join table between `Portfolio` and `Stock`.
