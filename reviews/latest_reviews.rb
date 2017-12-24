require 'watir'

$locator = {
  see_more: "//*[@id='body-content']/div/div/div[1]/div[2]/div[2]/div[1]/div[4]/button[2]",
  value_dropdown: 'dropdown-menu',
  new: "//*[contains(text(), 'Newest')]",
  review_text: 'single-review'
}

class FetchResponse
  def initialize(_package = 'nil')
    @latest = CSV.open('csv/latest_reviews.csv', 'wb')
    @package = PACKAGE_NAME
    @url = "https://play.google.com/store/apps/details?id=#{@package}&hl=en"
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

  def fetch_reviews(reviews_date)
    get_reviews = true
    puts 'Fetching Reviews for Date : ' + reviews_date.to_s + '-' + Time.new.month.to_s
    # @b=Watir::Browser.new :phantomjs
    # @b.driver.manage.window.maximize
    @b = create_driver
    @b.goto(@url)
    @b.wait 15
    scroll_down(4)
    @b.element(xpath: $locator[:see_more]).wait_until_present(60)
    @b.element(xpath: $locator[:see_more]).click
    @b.element(class: $locator[:value_dropdown]).wait_until_present(60)
    @b.button(class: $locator[:value_dropdown]).click
    sleep 2
    @b.element(xpath: $locator[:new]).click
    sleep 2
    @b.element(xpath: $locator[:see_more]).hover
    while get_reviews
      texts = @b.divs(class: $locator[:review_text])
      texts.each_with_index do |text, index|
        next if text.text.empty?
        date = Date.parse(text.text.split("\n")[0])
        if date.day == reviews_date.to_i
          @latest << [(text.text.split("\n")[0]).to_s, (text.text.split("\n")[1]).to_s]
          get_reviews = true
        elsif date.day == reviews_date.to_i - 1
          get_reviews = false
      end
      end
      sleep 2
      @b.element(xpath: $locator[:see_more]).click
    end
    close
  end

  def scroll_down(count)
    puts 'Scrolling the page'
    (0..count).each do
      @b.execute_script("window.scrollBy(0,200)")
    end
    sleep 3
  end

  def close
    @b.close
    @latest.close
  end
end
