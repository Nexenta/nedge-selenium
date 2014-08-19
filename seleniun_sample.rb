require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "SeleniunSample" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://code.google.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_seleniun_sample" do
    # ERROR: Caught exception [unknown command []]
    @driver.get(@base_url + "/p/selenium/downloads/list")
    @driver.find_element(:link, "Project Home").click
    @driver.find_element(:link, "Project feeds").click
    @driver.find_element(:link, "Atom").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
