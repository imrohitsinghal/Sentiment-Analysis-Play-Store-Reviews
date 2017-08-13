require 'sentimental'
require 'CSV'
require_relative 'features/app_features.rb'
require 'nokogiri'
require 'mustache'

$csv2 = CSV.open("negative_reviews.csv", "wb")
$csv3 = CSV.open("functionality_reviews.csv", "wb")
$csv3 << ['area', 'review']

analyzer = Sentimental.new
analyzer.load_defaults
analyzer.threshold = 0.1

def affected_features string
  FEATURES.each do |keyword|
    if string.include?keyword
      $csv3 << [keyword,string]
      break
    end
  end
end

CSV.foreach("reviews_file.csv") do |row|
  if analyzer.sentiment row[1] != 'positive'
    $csv2 << [row[1]]
    affected_features row[1]
  end
end



