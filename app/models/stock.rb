class Stock < ActiveRecord::Base
  
  has_many :user_stocks
  has_many :users, through: :user_stocks
  attr_accessor :can_be_added 
  
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
  
  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.company_name
    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.company_name)
    new_stock.last_price = looked_up_stock.latest_price
    new_stock
  end
  
  # 
  # stock cannot be added beacuse alreay present
  #
  # number of stocks greter than 10
  #
  
  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price} (Closing)" if closing_price
    
    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price
    'Unavailable'
  end
end
