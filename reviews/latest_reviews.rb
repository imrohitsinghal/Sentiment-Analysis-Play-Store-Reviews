require 'watir'

$locator = {
    see_more: "//*[text()='Read All Reviews']",
    value_dropdown: "//*[text()='Most helpful first']",
    new: "//div[@class='OA0qNb ncFHed']/div[1]",
    review_text: 'div.UD7Dzf',
    review_date: "//div[@class='bAhLNe kx8XBd']/div/span[@class='p2TkOb']",
    review_rating: "//span[@class='qC3s2c']/div/div"
}

class FetchResponse
  def initialize(package)
    @filtered = CSV.open('csv/filtered_reviews.csv', 'wb')
    @newest = CSV.open('csv/newest_reviews.csv', 'wb')
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
    requested_date = requested_date.split(",")
    is_get_reviews = true
    puts '***** Fetching Reviews for Date : ' + requested_date.to_s + '-' + Date.today.strftime("%B").to_s
    order_reviews_by_newest
    while is_get_reviews
      i, j, k = 0, 0, 0
      list = []
      scroll_down(12)
      sleep(2)
      review_text = @driver.elements(css: $locator[:review_text])
      review_date = @driver.elements(xpath: $locator[:review_date])
      puts "\n ****** Reviews Count: " + review_text.size.to_s
      while i < review_text.size do
        while j <= i do
          unless review_text[i].text.empty?
            list << [review_date[j].text, review_text[i].text]
          end
          j += 1
        end
        i += 1
      end

      puts "\n *****  Adding Reviews to CSV  ***** \n"
      while k < list.size do
        next if list[k].empty?
        # require 'pry'
        # binding.pry
        actual_review_date = list[k][0].split(',')[0].split(' ')[1]
        if !(requested_date.select {|str| str == actual_review_date}).empty?
          @filtered << [list[k][0], list[k][1]]
        else
          @newest << [list[k][0], list[k][1]]
          is_get_reviews = false
        end
        k += 1
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
    puts "\n ***** Sorting by - Newest Reviews ***** \n"
    @driver.element(xpath: $locator[:new]).click
  end

  def get_review_comment(review)
    @driver.elements(css: $locator[:review_date])
  end

  def scroll_down(count)
    begin
      (0..count).each do
        puts 'Scrolling the page to load more reviews on the page'
      @driver.execute_script('window.scrollBy(0,1000)')
        sleep(0.5)
      end
  rescue UnknownError
      puts "\n Unable to Scroll \n"
    end
  end

  def scroll_till_found(locator)
    found = false
    count = 0
    begin
      while found != true && count < 15
        if @driver.element(locator).scroll_into_view
          found = true
        else
          @driver.execute_script("window.scrollBy(0,250)")
          sleep 3
          count += 1
        end
      end
    rescue RuntimeError
      puts "Unable to find element on complete screen \n"
    end
  end

  def close
    puts "\n **** Closing the browser **** \n"
    @driver.close
    @filtered.close
    @newest.close
  end
end
