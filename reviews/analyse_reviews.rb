require_relative '../features/app_features'
require 'yaml'

require 'aylien_text_api'

class AnalyzeReviews
  def initialize
    @negative = CSV.open('csv/negative_reviews.csv', 'wb')
    @functionality = CSV.open('csv/functionality_reviews.csv', 'wb')
    # @suggestions = CSV.open('csv/suggestions.csv', 'wb')
    @functionality << %w[AREA FEEDBACK]
  end

  def affected_features(review) FEATURES.each do |keyword|
    if review.include? keyword.downcase
      @functionality << [keyword, review]
      break
    end
  end
  end

  def enter_into_csv(file, review)
    file << [review]
  end

  def analyze_each_review
    puts "***** Analyzing all the newest Reviews *****"
    textapi = AylienTextApi::Client.new
    CSV.foreach('./csv/latest_reviews.csv') do |row|
      unless row.empty?
        review_map = textapi.sentiment text: row[1]
        if review_map[:polarity].to_s == 'negative'
          enter_into_csv @negative, row
          affected_features row[1]
        # elsif review_map[:polarity].to_s == 'positive' && review_map[:polarity_confidence] < 0.81 && review_map[:subjectivity_confidence] > 0.99
        #   enter_into_csv @suggestions, row[1]
        elsif review_map[:polarity].to_s == 'neutral' && review_map[:polarity_confidence] > 0.56
          enter_into_csv @negative, row[1]
          affected_features row[1]
        end
      end
    end
  end

  def close_files
    @negative.close
    @functionality.close
    # @suggestions.close
  end
end
