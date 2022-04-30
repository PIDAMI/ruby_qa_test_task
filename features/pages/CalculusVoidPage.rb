require 'selenium-webdriver'


class CalculusVoidPage
    
    URL = "https://calcus.ru/kalkulyator-ipoteki"
    
    COST_CALC_TOGGLE_XPATH = "//a[@data-autofocus='cost']"
    CREDIT_SUM_CALC_TOGGLE_XPATH = "//a[@data-autofocus='credit_sum']"
    HEADER_XPATH = "//h1[contains('Ипотечный калькулятор', text())]"
    INPUT_FIELD_LEFT_TEXT_XPATH_FORMAT = "//*[contains('%s', text())]"
    INPUT_FIELD_LEFT_TEXTS = ['Стоимость недвижимости', 'Первоначальный Взнос', 
        'Сумма кредита', 'Срок кредита', 'Процентная ставка', 'Тип ежемесячных платежей']

    COST_INPUT_XPATH = "//input[@name='cost']"
    INITIAL_FEE_INPUT_XPATH = "//input[@name='start_sum']"
    INITIAL_FEE_VALUE_XPATH = "//div[@class='calc-input-desc start_sum_equiv']"
    CREDIT_SUM_VALUE_XPATH = "//span[@class='credit_sum_value text-muted']"
    PERIOD_INPUT_XPATH = "//input[@name='period']"
    PERCENT_INPUT_XPATH = "//input[@name='percent']"

    INITIAL_FEE_DROPBOX_XPATH = "//select[@name='start_sum_type']"

    ANNUITY_TYPE_RADIOBOX_XPATH = "//input[@name='payment_type' and @value='1']"
    DIFFERENTIATED_TYPE_RADIOBOX_XPATH = "//input[@name='payment_type' and @value='2']"

    CALCULATE_BUTTON_XPATH = "//input[@value='Рассчитать']"
    
    MONTHLY_PAYMENT_VALUE_XPATH = "//div[@class='calc-result-value result-placeholder-monthlyPayment']"

    PROGRESS_BAR_XPATH = "//div[@class='calc-loading']"

    def setup
        @driver = Selenium::WebDriver.for(:chrome)
    end


    def open_site
        @driver.get(URL)
        @driver.find_element(:xpath => HEADER_XPATH)
        @driver.find_element(:xpath => COST_CALC_TOGGLE_XPATH)
        for text in INPUT_FIELD_LEFT_TEXTS do
            @driver.find_element(:xpath => INPUT_FIELD_LEFT_TEXT_XPATH_FORMAT % [text])
        end
        
        @cost_input = @driver.find_element(:xpath => COST_INPUT_XPATH)
        @initial_fee_input = @driver.find_element(:xpath => INITIAL_FEE_INPUT_XPATH)
        @initial_fee_value = @driver.find_element(:xpath => INITIAL_FEE_VALUE_XPATH)
        @credit_sum_value = @driver.find_element(:xpath => CREDIT_SUM_VALUE_XPATH)
        @period_input = @driver.find_element(:xpath => PERIOD_INPUT_XPATH)
        @percent_input = @driver.find_element(:xpath => PERCENT_INPUT_XPATH)

        @initial_fee_dropbox = @driver.find_element(:xpath => INITIAL_FEE_DROPBOX_XPATH)
        @annuity_type = @driver.find_element(:xpath => ANNUITY_TYPE_RADIOBOX_XPATH)
        @differentiated_type = @driver.find_element(:xpath => DIFFERENTIATED_TYPE_RADIOBOX_XPATH)
        
        @calculate_button = @driver.find_element(:xpath =>CALCULATE_BUTTON_XPATH)

        @progress_bar = @driver.find_element(:xpath => PROGRESS_BAR_XPATH)

    end

    def set_cost(value)
        @cost_input.send_keys(value)
    end

    def set_initial_fee_option(option_value)
        option = Selenium::WebDriver::Support::Select.new(@initial_fee_dropbox)
        option.select_by(:text, option_value)
    end 

    def set_initial_fee_value(value)
        @initial_fee_input.send_keys(value)
    end 
        
    def get_initial_fee_calc_value()
        return @initial_fee_value.text.delete_prefix('(').delete_suffix(')')
    end

    def get_credit_sum_calc_value()
        return @credit_sum_value.text + " руб."
    end
    

    def set_period_value(value)
        @period_input.send_keys(value)
    end
    
    def set_percent_value(value)
        @percent_input.send_keys(value)
    end

    def is_annuity_type_checked()
        return @annuity_type
    end

    def press_calculate_button()
        @calculate_button.click
    end

    def get_monthly_payment()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until do
            @progress_bar.attribute("style").include?("display: none;")
        end

        return @driver.find_element(:xpath => MONTHLY_PAYMENT_VALUE_XPATH).text
    end

end


