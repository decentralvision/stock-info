class StockInfo::Stock
  attr_accessor :company, :symbol, :daily_change, :price, :news, :earnings, :rvol, :optionable, :short_ratio
  @@all = []
  def initialize(symbol)
    @symbol = symbol
    @news = []
    get_info(symbol)
    @@all << self
  end

  def self.create_or_return(symbol)
    if self.market_open && @@all.any? {|stock| stock.symbol == symbol}
      if self.market_open
        stock = @@all.select {|stock| stock.symbol == symbol }[0]
        stock.get_info(symbol)
        stock
      else
        stock = @@all.select {|stock| stock.symbol == symbol}[0]
      end
    else
      self.new(symbol)
    end
  end

  def self.market_open
    time = Time.now.localtime('-05:00')
    (time.saturday? || time.sunday? || time.hour > 20 || time.hour < 4) ? false : true
  end

  def self.check_symbol(symbol)
    open("https://finviz.com/quote.ashx?t=#{symbol}").read
    true
  rescue StandardError => e
    false
  end

  def get_info(symbol)
    doc = Nokogiri::HTML(open("https://finviz.com/quote.ashx?t=#{symbol}"))
    @company = doc.css('table.fullview-title tr')[1].text
    @rvol = doc.css('table.snapshot-table2 td.snapshot-td2')[-14].text
    @daily_change = doc.css('table.snapshot-table2 td.snapshot-td2')[-1].text
    @price = doc.css('table.snapshot-table2 td.snapshot-td2')[-7].text
    @optionable = doc.css('table.snapshot-table2 td.snapshot-td2')[-18].text
    @short_ratio = doc.css('table.snapshot-table2 td.snapshot-td2')[22].text
    @earnings = doc.css('table.snapshot-table2 td.snapshot-td2')[-10].text
    @earnings = 'None (ETF)' if earnings == '-'
  end

  def print_news
    StockInfo::News.get_news(self)
    @news.each.with_index(1) do |article, i|
      puts "#{i} | #{article.title} - #{article.source}"
    end
  end

  def print_info
    puts "#{company} - Price: #{price} - Change: #{daily_change} - Relative Volume: #{rvol} - Earnings Date: #{earnings} - Optionable: #{optionable} - Short Ratio: #{short_ratio}"
  end

  def self.print_trending
    StockInfo::Scraper.trending.each do |stock|
      puts "#{stock.symbol} - Price: #{stock.price} - Change: #{stock.daily_change} - Relative Volume: #{stock.rvol}"
    end
  end

end
