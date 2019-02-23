class StockInfo::Scraper
    @@trending = []
    def self.trending
        if StockInfo::Stock.market_open || @@trending.empty?
          i = 0
          doc = Nokogiri::HTML(open('https://finviz.com/screener.ashx?v=110&s=ta_mostactive'))
          10.times do
            symbol = doc.css('tr.table-dark-row-cp a.screener-link-primary')[i].text
            i += 1
            @@trending << StockInfo::Stock.create_or_return(symbol)
          end
        end
        @@trending
    end
end