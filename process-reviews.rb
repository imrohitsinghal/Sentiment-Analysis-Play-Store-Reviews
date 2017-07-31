require 'sentimental'
require 'CSV'
require_relative 'features/app_features.rb'

$csv2 = CSV.open("negative_reviews.csv", "wb")
analyzer = Sentimental.new
analyzer.load_defaults
analyzer.threshold = 0.1

def extract_words(string)
  string.to_s.downcase.scan(/([\w']+|\S{2,})/).flatten
end

def affected_features string
  extract_words(string).each do |word|
    if FEATURES.include?(word)
      print word + "\n"
    end
  end
end

CSV.foreach("reviews_file.csv") do |row|
  if analyzer.sentiment row[1] != 'positive'
      $csv2 << [row[1]]
      affected_features row[1]
  end
end
