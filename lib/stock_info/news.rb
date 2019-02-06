class StockInfo::Stock::News
    attr_accessor :symbol, :date, :title, :source, :link
    def self.get_news(symbol)
        news = []
        doc = Nokogiri::HTML(open("https://finviz.com/quote.ashx?t=#{symbol}"))
        i=0
        10.times do 
            article = self.new
            article.symbol = symbol
            article.date = doc.css("table#news-table.fullview-news-outer tr")[0].css("td")[0].text
            article.title = doc.css("table#news-table.fullview-news-outer tr")[i].css(".tab-link-news").text
            article.source = doc.css("table#news-table.fullview-news-outer tr span")[0].text
            article.link = doc.css("table#news-table.fullview-news-outer tr td a")[i].attribute("href").value
            news << article
            i+=1
        end
        news
    end
    def self.open_url(link)
        if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
            system "start #{link}"
        elsif RbConfig::CONFIG['host_os'] =~ /darwin/
            system "open #{link}"
        elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
            system "xdg-open #{link}"
        end
    end
end