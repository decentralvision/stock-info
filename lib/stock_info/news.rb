class StockInfo::Stock::News
    attr_accessor :symbol,  :title, :source, :link
    def self.get_news(symbol)
        news = []
        doc = Nokogiri::HTML(open("https://finviz.com/quote.ashx?t=#{symbol}"))
        i=0
        10.times do 
            article = self.new
            article.symbol = symbol
            article.title = doc.css("table#news-table.fullview-news-outer tr")[i].css(".tab-link-news").text
            article.source = doc.css("table#news-table.fullview-news-outer tr span").reject{|source| source.css(span.body-table-news-gain)}[i].text
            binding.pry
            article.link = doc.css("table#news-table.fullview-news-outer tr td a")[i].attribute("href").value
            news << article
            i+=1
        end
        news
    end
    def self.news_menu(stock)
        stock.print_news
        puts "Enter the number of an article you would like to open in your web browser, or type 'menu' to return to the main menu"
        input = gets.strip
        if input.to_i > 0 && input.to_i <= 10
            self.open_url(stock.news[(input.to_i) -1].link)
        elsif input.downcase == 'menu'
            menu
        end
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