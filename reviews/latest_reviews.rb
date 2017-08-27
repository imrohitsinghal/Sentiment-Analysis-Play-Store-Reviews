require 'watir-webdriver'

$locator = {
    see_more: "//*[@id='body-content']/div/div/div[1]/div[2]/div[2]/div[1]/div[4]/button[2]",
    value_dropdown: 'dropdown-menu',
    new: "//*[contains(text(), 'Newest')]",
    review_text: "single-review",
}

class FetchResponse

  def initialize(package = 'nil')
    @csv = CSV.open("csv/latest_reviews.csv", "wb")
    @package = PACKAGE_NAME
    @url = "https://play.google.com/store/apps/details?id=#{@package}&hl=en"
  end

  def fetch_reviews
    puts "Fetching Latest Reviews"
    @b=Watir::Browser.new :phantomjs
    @b.driver.manage.window.maximize
#   @b = create_driver
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
        j=0
        texts = @b.divs(:class => $locator[:review_text])
        while j < texts.count
          if (texts[j].text).size>0
            @csv << ["#{texts[j].text.split("\n")[0]}", "#{texts[j].text.split("\n")[1]}"]
          end
          j+=1
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
