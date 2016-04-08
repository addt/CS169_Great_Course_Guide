Then /there should be the button "(.*)"/ do |button|
  should have_button button
end

num_profs = 0
Given /the following professors exist/ do |prof_table|
  num_profs = 0
  prof_table.hashes.each do |prof|
    p = Professor.create(prof)
    p.courses.create({number: "Spoon", name: "Fork", rating: -num_profs, term: "SP14"})
    num_profs += 1
  end
end

num_courses = 0
Given /the following courses exist/ do |course_table|
  num_courses = 0
  course_table.hashes.each do |course|
    c = Course.create(course)
  end
end

Given /the following courses are going to be taught/ do |course_table|
  course_table.hashes.each do |course|
    c = DraftCourse.create(course)
  end
end

And /professors teach the appropriate courses/ do
  cup = Professor.find_by_name("Cup")
  dog = Professor.find_by_name("Dog")
  cat = Professor.find_by_name("Cat")
  cup.courses.create({number: "CS61A", name: "ABCD", rating: 2, term: "SP14"})
  cup.courses.create({number: "CS61B", name: "EFGH", rating: 5, term: "SP14"})
  dog.courses.create({number: "CS61C", name: "IJKL", rating: 2, term: "SP14"})
  cat.courses.create({number: "CS70", name: "MNOP", rating: 2, term: "SP14"})
  cat.courses.create({number: "CS61A", name: "ABCD", rating: 3, term: "SP15"})
end

Given /the following prerequisites exist/ do |prereq_table|
  prereq_table.hashes.each do |course|
    c = Course.find_by(number: course[:course]).prereqs.create({:number => course[:number]})
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  e1index = page.body.index(e1)
  e2index = page.body.index(e2)
  e2index.should be > e1index
end

Then /I should not see "(.*)" before "(.*)"/ do |e1, e2|
  e1index = page.body.index(e1)
  e2index = page.body.index(e2)
  e2index.should be < e1index
end

And /I login as "(.*)"/ do |name|
  fill_in("First Name", :with => name)
  fill_in("Last Name", :with => "Jackson")
  fill_in("Email", :with => "mjhomie@gmail.com")
  click_button("Continue", match: :first)
  should have_button("Add Class")
  click_button("Finish", match: :first)
end

Given /I have "(.*)" in my classes/ do |course_name|
  click_link("Edit", match: :first)
  check(course_name)
  check("#{course_name.split("-")[0]}" + "-taken")
  click_button("Save", match: :first)
end

Given /I want to take "(.*)"/ do |course_name|
  click_link("Edit", match: :first)
  check(course_name)
  click_button("Save", match: :first)
end
