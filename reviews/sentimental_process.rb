require 'sentimental'
require_relative '../features/app_features'

class SentimentalProcess
  def initialize
    @csv2 = CSV.open('csv/negative_reviews.csv', 'wb')
    @csv3 = CSV.open('csv/functionality_reviews.csv', 'wb')
  end

  def affected_features(string)
    FEATURES.each do |keyword|
      if string.include? keyword.downcase
        @csv3 << [keyword, string]
        break
      end
    end
  end

  def process
    analyzer = Sentimental.new
    analyzer.load_defaults
    analyzer.threshold = 0.1
    CSV.foreach('csv/latest_reviews.csv') do |row|
      if analyzer.sentiment row[1] != 'positive'
        @csv2 << [row[1]]
        affected_features row[1]
      end
    end
    @csv3.close
    @csv2.close
  end

end
