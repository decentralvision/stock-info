# Our CLI controller
class StockInfo::CLI
  def call
    trending_tickers
    menu
    goodbye
  end

  def trending_tickers
    puts "Loading today's trending stocks..."
    StockInfo::Stock.print_trending
  end

  def menu
    input = nil
    while input != 'exit'
      puts 'Enter the ticker symbol of a stock you would like more info on.'
      puts "Other commands: 'exit' - exits stock-info, 'trending' - refresh trending stocks."
      input = gets.strip.downcase
      if input == 'trending'
        trending_tickers
      elsif StockInfo::Stock.check_symbol(input.upcase) == true
        stock = StockInfo::Stock.new(input.upcase)
        stock.print_info
        puts 'View recent news articles related to this stock? (yes/no)'
        news_bool = gets.strip[0].downcase
        input = StockInfo::News.news_menu(stock) if news_bool == 'y'
      elsif input != 'exit'
        puts 'Please input a command or ticker symbol'
      end
    end
  end

  def goodbye
    puts 'Goodbye and good luck!'
  end
end
