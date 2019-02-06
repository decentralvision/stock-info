# Our CLI controller
class StockInfo::CLI
    def call        
        trending_tickers
        menu
        goodbye
    end
    def trending_tickers
        puts "Today's trending stocks:"
        StockInfo::Stock.trending.each do |stock|
            puts "#{stock.symbol} | #{stock.daily_change} | #{stock.price}"
        end
    end
    def menu
        input = nil
        while input != 'exit'
            puts "Enter the ticker symbol of the stock you would like more info on."
            puts "Other commands: 'exit' - exits stock-info, 'trending' - shows trending stocks"
            input = gets.strip.downcase
            if input == 'trending'
                trending_tickers
            elsif StockInfo::Stock.check_symbol(input.upcase) == true
                stock = StockInfo::Stock.new(input.upcase)
                puts "#{stock.symbol} | #{stock.daily_change} | #{stock.price}"
                puts "Would you like to view recent news articles related to this stock? (yes/no)"
                news_bool = gets.strip[0]
                if news_bool == 'y'
                    stock.news.each.with_index(1) do |article, i|
                        puts "#{i} | #{article.date} | #{article.title} | #{article.source}"
                    end
                end
            elsif input != 'exit'
                puts 'Please input a command or ticker symbol'
            end
        end
    end
    def goodbye
        puts "Goodbye and good luck!"
    end
end