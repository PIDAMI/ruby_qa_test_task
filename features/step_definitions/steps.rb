require_relative '../pages/CalculusVoidPage.rb'

    Given("I'm at Calculus site") do
        @calculus_page = CalculusVoidPage.new
        @calculus_page.setup
        @calculus_page.open_site
    end
    
    When('I input {string} in Real estate cost input field') do |cost_value|
        @calculus_page.set_cost(cost_value)
    end

    
    And('I choose {string} option in Initial fee dropbox') do |option|
        @calculus_page.set_initial_fee_option(option)
    end


    And('I input {string} in Initial fee input field') do |fee_value|
        @calculus_page.set_initial_fee_value(fee_value)
    end

    Then("Text {string} is displayed in Initial fee section") do |expected_fee_value|
        actual = @calculus_page.get_initial_fee_calc_value
        expect(actual).to eq(expected_fee_value)
    end

    And("Amount of credit field value is {string}") do |expected_credit_value|
        @credit_sum = expected_credit_value.gsub("руб.","").gsub(" ","")
        actual = @calculus_page.get_credit_sum_calc_value
        expect(actual).to eq(expected_credit_value)
    end

    
    When("I input {string} in Credit period input field") do |period_value|
        @period_years = period_value
        @calculus_page.set_period_value(period_value)
    end

    And("I input a random number in Percent input field") do
        @percent = random_percent
        @calculus_page.set_percent_value(@percent)
    end

    And("I click Calculate button") do
        @calculus_page.press_calculate_button
    end 

    
    Then("Value of monthly payment is calculated with respect to formula") do
        expected_payment = calculate_monthly_payment(@credit_sum, @percent, @period_years)
        actual_payment = @calculus_page.get_monthly_payment.gsub(" ","").gsub(",",".")
        expect(actual_payment).to eq(expected_payment)
    end

    def calculate_monthly_payment(sum, percent, number_years)
        sum = sum.to_f
        monthly_percent = percent.to_f / 12 * 0.01
        months = number_years.to_i * 12

        return (sum * monthly_percent * (1 + monthly_percent)**months / ((1 + monthly_percent)**months - 1)).round(2).to_s
    end

    def random_percent()
        return rand(5..12).to_s
    end

