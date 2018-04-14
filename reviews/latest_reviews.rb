require 'watir'

$locator = {
  see_more: "//*[text()='Read All Reviews']",
  value_dropdown: "//*[text()='Most helpful first']",
  new: "//div[@class='OA0qNb ncFHed']/div[1]",
  review_text: 'div.Z8UXhc',
  review_date: 'span.oldIDd',
  review_rating: "//span[@class='qC3s2c']/div/div"
}

class FetchResponse
  def initialize(package)
    @latest = CSV.open('csv/latest_reviews.csv', 'wb')
    @all = CSV.open('csv/all_reviews.csv', 'wb')
    url = "https://play.google.com/store/apps/details?id=#{package}&hl=en"
    @driver = create_driver
    @driver.goto(url)
  end

  def create_driver
    driver_path = 'mac/chromedriver'
    driver = Selenium::WebDriver.for :chrome, driver_path: driver_path
    browser = Watir::Browser.new(driver)
    at_exit do
      sleep(2)
      browser.quit
    end
    browser
  end

  def fetch_reviews(requested_date)
    is_get_reviews = true
    puts '***** Fetching Reviews for Date : ' + requested_date.to_s + '-' + Time.new.month.to_s
    order_reviews_by_newest
    while is_get_reviews
      i,j,k=0,0,0
      list=[]
      scroll_down(20)
      sleep(5)
      review_text = @driver.elements(css: $locator[:review_text])
      review_date = @driver.elements(css: $locator[:review_date])

      while i < review_text.size do
        while j<= i do
          unless review_text[i].text.empty?
            list << [review_date[j].text, review_text[i].text]
          end
          j+=1
        end
        i+=1
      end

      puts "*****  Adding Review to CSV  *****"
      while k < list.size  do
        next if list[k].empty?
        actual_review_date = list[k][0].split(',')[0]
        if (actual_review_date.to_s).include?(requested_date.to_s)
          @latest << [list[k][0], list[k][1]]
        else
          @all << [list[k][0], list[k][1]]
          is_get_reviews = false
        end
        k+=1
      end
    end
    close
  end

  def order_reviews_by_newest
    scroll_till_found(xpath: $locator[:see_more])
    @driver.element(xpath: $locator[:see_more]).click
    @driver.element(xpath: $locator[:value_dropdown]).wait_until_present timeout: 2
    @driver.element(xpath: $locator[:value_dropdown]).click
    @driver.element(xpath: $locator[:new]).wait_until_present timeout: 5
    puts "***** Sorting by All Newest Reviews *****"
    @driver.element(xpath: $locator[:new]).click
  end

  def get_review_comment(review)
    @driver.elements(css: $locator[:review_date])
  end

  def scroll_down(count)
    puts 'Scrolling the page'
    (0..count).each do
      @driver.execute_script('window.scrollBy(0,500)')
    end
  end

  def scroll_till_found(locator)
    found = false
    count=0
    begin
      while found != true && count<15
        if @driver.element(locator).exists?
          found = true
        else
          @driver.execute_script("window.scrollBy(0,250)")
          sleep 3
          count +=1
        end
      end
    rescue RuntimeError
      puts "Unable to find element on complete screen"
    end
  end

  def close
    puts "**** Closing the browser ****"
    @driver.close
    @latest.close
  end
end
