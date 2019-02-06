class StockInfo::Stock
    attr_accessor :symbol, :daily_change, :price, :news
    def initialize(symbol)
        @symbol = symbol
        self.get_info(symbol)
    end
    def self.check_symbol(symbol)
        begin
            open("https://finviz.com/quote.ashx?t=#{symbol}").read
            true
        rescue => e
            false
        end
    end
    def get_info(symbol)
        doc = Nokogiri::HTML(open("https://finviz.com/quote.ashx?t=#{symbol}"))
        self.daily_change = doc.css("table.snapshot-table2 td.snapshot-td2")[-1].text
        self.price = doc.css("table.snapshot-table2 td.snapshot-td2")[-7].text
        self.news = News.get_news(symbol)
    end
    def self.trending
        trending = []
        i = 0
        doc = Nokogiri::HTML(open("https://finviz.com/screener.ashx?v=110&s=ta_mostactive"))
        10.times do 
            symbol = doc.css("tr.table-dark-row-cp a.screener-link-primary")[i].text
            i += 1
            trending << self.new(symbol)
        end
        trending
    end
end