require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'csv'

$csv = CSV.open("reviews_file.csv", "wb")
def getReviews package
  page_info = Nokogiri::HTML(open("https://play.google.com/store/apps/details?id=#{package}&hl=en"))
  reviews = page_info.css('div.review-body.with-review-wrapper')
  reviews.each_with_index do |review, index|
    # rating = page_info.css('div.tiny-star.star-rating-non-editable-container')[i].text.strip
    unless review.nil?
      review_text = review.text
      $csv << ["#{index}","#{review_text}"]
    end
  end
end

package_name = "<package_name>"
getReviews package_name