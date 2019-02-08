Give a list of trending tickers and their % change : https://finance.yahoo.com/trending-tickers
Scrape news articles for a given stock ticker symbol https://finviz.com/quote.ashx?t="ticker symbol"

Things to work on:

Referencing with namespace StockInfo::Stock is this correct? 

DRY code

Get rid of system error from opening browser

Can't pull data from :         short_doc = Nokogiri::HTML(open("https://www.nakedshortreport.com/company/#{symbol}"))
