require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'csv'

$csv = CSV.open("reviews_file.csv", "wb")
def getReviews package
  page_info = Nokogiri::HTML(open("https://play.google.com/store/apps/details?id=#{package}&hl=en"))
  reviews = page_info.css('div.review-body.with-review-wrapper')
  j=0
  while(j<reviews.count)
    # rating = page_info.css('div.tiny-star.star-rating-non-editable-container')[i].text.strip
    if !reviews[j].nil?
      review_text = reviews[j].text
      $csv << ["#{j}","#{review_text}"]
    end
    j+=1
  end
end


package_name = "<package_name>"
getReviews package_name
