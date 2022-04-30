Feature: Mortgage calculation
    Scenario: Check formula accuracy
     Given I'm at Calculus site
     When I input "12000000" in Real estate cost input field
     And I choose "%" option in Initial fee dropbox
     And I input "20" in Initial fee input field
     Then Text "2 400 000 руб." is displayed in Initial fee section
     And Amount of credit field value is "9 600 000 руб."
     When I input "20" in Credit period input field
     And I input a random number in Percent input field
     And I click Calculate button
     Then Value of monthly payment is calculated with respect to formula  