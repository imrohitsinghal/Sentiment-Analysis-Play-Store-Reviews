require 'watir'

$locator = {
  see_more: "//*[@id='body-content']/div/div/div[1]/div[2]/div[2]/div[1]/div[4]/button[2]",
  value_dropdown: 'dropdown-menu',
  new: "//*[contains(text(), 'Newest')]",
  review_text: 'single-review'
}

class FetchResponse
  def initialize(package)
    @latest = CSV.open('csv/latest_reviews.csv', 'wb')
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
    puts 'Fetching Reviews for Date : ' + requested_date.to_s + '-' + Time.new.month.to_s

    order_reviews_by_newest

    while is_get_reviews
      reviews = @driver.divs(class: $locator[:review_text])
      reviews.each do |review|
        next if review.text.empty?
        actual_review_date = get_review_date review
        if actual_review_date.day == requested_date.to_i
          @latest << [actual_review_date.to_s, (get_review_comment review)]
        elsif actual_review_date.day == requested_date.to_i - 1
          is_get_reviews = false
        end
      end
      sleep 2
      @driver.element(xpath: $locator[:see_more]).click
    end
    close
  end

  def order_reviews_by_newest
    scroll_down(4)
    @driver.element(xpath: $locator[:see_more]).wait_until_present timeout: 30
    @driver.element(xpath: $locator[:see_more]).click
    @driver.element(class: $locator[:value_dropdown]).wait_until_present timeout: 30
    @driver.button(class: $locator[:value_dropdown]).click
    sleep 2
    @driver.element(xpath: $locator[:new]).click
    sleep 2
    @driver.element(xpath: $locator[:see_more]).hover
  end

  def get_review_comment(review)
    (review.text.split("\n")[1]).to_s
  end

  def get_review_date(review)
    Date.parse(review.text.split("\n")[0])
  end

  def scroll_down(count)
    puts 'Scrolling the page'
    (0..count).each do
      @driver.execute_script('window.scrollBy(0,200)')
    end
    sleep 3
  end

  def close
    @driver.close
    @latest.close
  end
end
