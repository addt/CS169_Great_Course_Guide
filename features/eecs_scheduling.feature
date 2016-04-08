Feature: Schedule Planning for EECS Courses

  As a user
  So I can plan my technical courses for the next year
  I would like to see a recommended list of courses to take based on my completed prerequisites

Background: I have classes

  Given the following courses exist:
  | title | number |
  | ABCD  | CS61A  |
  | EFGH  | CS61B  |
  | IJKL  | CS61C  |
  | MNOP  | CS70   |
  | Fork  | Spoon  |
  And the following professors exist:
  | name |
  | Cup  |
  | Dog  |
  | Cat  |
  And I am on the welcome page
  And I login as "Michael"
  And professors teach the appropriate courses
  Given I have "CS61A-choice" in my classes
  And I am on the classes page


Scenario: Displays recommended classes to take in the future
  Given the following courses are going to be taught:
  | title | number | term       | professor |
  | EFGH  | CS61B  | Fall 2016  | Cup       |
  When I follow "Recommended Schedule"
  Then I should see "Classes You Should Take"
  Then I should see "CS61B"
  Then I should see "Cup"
  Then I should see "3.5"

Scenario: The user isn't eligible to take any classes in the upcoming year (sad path)
  Given the following courses are going to be taught:
  | title | number | term       | professor |
  | MNOP  | CS70   | Fall 2016  | Cat       |
  When I follow "Recommended Schedule"
  Then I should see "Classes You Should Take"
  Then I should see "It seems you cannot take any classes offered next year"
  Then I should see "Please go see your advisor"

Scenario: The classes the user wants to take don't match what they can take (sad path)
  Given the following courses are going to be taught:
  | title | number | term       | professor |
  | EFGH  | CS61B  | Fall 2016  | Cup       |
  Given I want to take "CS61C-choice"
  When I follow "Recommended Schedule"
  Then I should see "Classes You Should Take"
  Then I should see "CS61B"
  And I should not see "CS61C"
