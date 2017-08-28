require 'watir-webdriver'

$locator = {
    see_more:       "//*[@id='body-content']/div/div/div[1]/div[2]/div[2]/div[1]/div[4]/button[2]",
    value_dropdown: 'dropdown-menu',
    new:            "//*[contains(text(), 'Newest')]",
    review_text:    "single-review",
}

class FetchResponse

  def initialize(package = 'nil')
    @csv     = CSV.open("csv/latest_reviews.csv", "wb")
    @package = PACKAGE_NAME
    @url     = "https://play.google.com/store/apps/details?id=#{@package}&hl=en"
  end

  def create_driver
    driver_path = "mac/chromedriver"
    driver      = Selenium::WebDriver.for :chrome, driver_path: driver_path
    browser     = Watir::Browser.new(driver)
    at_exit do
      sleep(2)
      browser.quit
    end
    browser
  end

  def fetch_reviews
    puts "Fetching Latest Reviews"
    # @b=Watir::Browser.new :phantomjs
    # @b.driver.manage.window.maximize
    @b = create_driver
    @b.goto(@url)
    @b.element(:xpath => $locator[:see_more]).wait_until_present
    @b.element(:xpath => $locator[:see_more]).click
    @b.element(:class => $locator[:value_dropdown]).wait_until_present
    @b.button(:class => $locator[:value_dropdown]).click
    sleep 2
    @b.element(:xpath => $locator[:new]).click
    (0..1).each do |i|
      sleep 2
      i=0
      while i<5
        texts = @b.divs(:class => $locator[:review_text])
        texts.each_with_index do |text, index|
          if (text.text).size>0
            @csv << ["#{text.text.split("\n")[0]}", "#{text.text.split("\n")[1]}"]
          end
        end
        sleep 2
        @b.element(:xpath => $locator[:see_more]).click
        i+=1
      end
    end
    close
  end

  def close
    @b.close
  end

end
