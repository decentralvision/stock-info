class StockInfo::Stock
    attr_accessor :company, :symbol, :daily_change, :price, :news, :earnings, :rvol, :optionable, :short_ratio
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
        self.company = doc.css('table.fullview-title tr')[1].text
        self.rvol = doc.css("table.snapshot-table2 td.snapshot-td2")[-14].text 
        self.daily_change = doc.css("table.snapshot-table2 td.snapshot-td2")[-1].text
        self.price = doc.css("table.snapshot-table2 td.snapshot-td2")[-7].text
        self.optionable = doc.css("table.snapshot-table2 td.snapshot-td2")[-18].text 
        self.short_ratio = doc.css("table.snapshot-table2 td.snapshot-td2")[22].text
        self.earnings = doc.css("table.snapshot-table2 td.snapshot-td2")[-10].text 
        if self.earnings == '-'
            self.earnings = "None (ETF)"
        end
    end
    def print_news
        self.news = News.get_news(self.symbol)
        self.news.each.with_index(1) do |article, i|
            puts "#{i} | #{article.title} - #{article.source}"
        end
    end
    def print_info
        puts "#{self.company} - Price: #{self.price} - Change: #{self.daily_change} - Relative Volume: #{self.rvol} - Earnings Date: #{self.earnings} - Optionable: #{self.optionable} - Short Ratio: #{self.short_ratio}"
    end
    def self.print_trending
        self.trending.each do |stock|
            puts "#{stock.symbol} - Price: #{stock.price} - Change: #{stock.daily_change} - Relative Volume: #{stock.rvol}"
        end        
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