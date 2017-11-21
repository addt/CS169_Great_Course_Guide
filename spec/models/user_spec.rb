require "spec_helper"
require "rails_helper"

describe User do
  describe "User CRUD" do
      #want a list of users
      before(:each) do
          User.destroy_all()
      end

      #create the user
      context "create the user" do
          it "should add the created user to the table" do
              User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              expect(User.find_by(:email => "jd@berkeley.edu").last_name).to eq ("Doe")
          end

          it "should reject a user with same uid" do
              User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              expect(User.new(:first_name => "Jon", :last_name => "Doh",
              :email => "jdd@berkeley.edu", :uid => "25403252")).to_not be_valid

          end

          it "should reject a user with same email" do
              User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              expect(User.new(:first_name => "Jon", :last_name => "Doh",
              :email => "jd@berkeley.edu", :uid => "65403262")).to_not be_valid
          end

          it "should add a user with the same name" do
              User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              expect(User.create(:first_name => "Jon", :last_name => "Doh",
              :email => "jdd@berkeley.edu", :uid => "65403262")).to be_valid
          end

          it "should reject users with missing values" do
               expect(User.create(:last_name => "Doh",
              :email => "jd@berkeley.edu", :uid => "65403262")).to_not be_valid

               expect(User.create(:first_name => "Jon",
              :email => "jd@berkeley.edu", :uid => "65403262")).to_not be_valid

               expect(User.create(:first_name => "Jon", :last_name => "Doh",
               :uid => "65403262" )).to_not be_valid

               expect(User.create(:first_name => "Jon", :last_name => "Doh",
              :email => "jd@berkeley.edu")).to_not be_valid
          end

      end
      context "update the user" do
          it "shoud update the user if they already exist" do
              User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              user = User.find_by(:uid => "25403252")
              expect(user.first_name).to eq("John")
              user.first_name = "James"
              user.save
              user = User.find_by(:uid => "25403252")
              expect(user.first_name).to eq("James")
          end
      end
      context "delete the user" do
          it "should delete a user that already exists" do
              User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              user = User.find_by(:uid => "25403252")
              expect(user.first_name).to eq("John")
              user.delete
              user = User.find_by(:uid => "25403252")
              expect(user).to eq(nil)
          end
      end

      context "read the user" do
         it "should return nil if a user is not in the model" do
             user = User.find_by(:uid => "00001")
             expect(user).to eq(nil)
         end

         it "should return the user if they are in the model" do
             User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
              user = User.find_by(:uid => "25403252")
              expect(user.first_name).to eq("John")
          end
      end
  end

  describe "get all the emails" do
      context "there are users with emails" do
          it "should get all of the emails" do
               User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )
               User.create(:first_name => "Jon", :last_name => "Doh",
              :email => "jdd@berkeley.edu", :uid => "65403262" )
              expect(User.all_emails).to include("jdd@berkeley.edu")
          end
      end
  end

  describe "get all the user courses" do
      it "should not get any courses if the user has no courses" do
          User.create(:first_name => "Jon", :last_name => "Doh",
                  :email => "jdd@berkeley.edu", :uid => "65403262")
          user = User.find_by(:uid => "65403262")
          expect(user.courses).to be_empty
      end

      it "should get all of the users courses" do
          Course.create(:number => "CS61A", :title => "Structure and Interpretation")
          course1 = Course.find_by(:number => "CS61A")
          User.create(:first_name => "Jon", :last_name => "Doh",
                  :email => "jdd@berkeley.edu", :uid => "65403262")
          user = User.find_by(:uid => "65403262")
          user.user_courses.create(number: "CS61A", title: "Structure and Interpretation")
          expect(user.courses).to_not be_empty
          user.save

      end

      it "should have all of the courses in alphabetical order" do
          Course.create(:number => "CS61A", :title => "Interpretation")
          Course.create(:number => "CS61B", :title => "Structure")
          Course.create(:number => "CS61C", :title => "Structure and Interpretation")
          User.create(:first_name => "John", :last_name => "Doe",
                  :email => "jd@berkeley.edu" , :uid => "25403252" )

          user = User.find_by(:uid => "25403252")
          user.user_courses.create(number: "CS61A", title: "Interpretation")
          user.user_courses.create(number: "CS61B", title: "Structure")
          user.user_courses.create(number: "CS61C", title: "Structure and Interpretation")
          expect(user.courses[0][:number]).to eq("CS61A")
          expect(user.courses[1][:number]).to eq("CS61B")
          expect(user.courses[2][:number]).to eq("CS61C")
          expect(user.courses.length).to eq(3)
      end
  end

  describe "Scheduling" do

    before (:each) do
      Professor.destroy_all
      UserCourse.destroy_all
      ProfessorCourse.destroy_all
      User.destroy_all
      Course.destroy_all
      Prereq.destroy_all

      @user = User.create(first_name: "John", last_name: "Doe", uid: "000", email: "jd@jd.com")
      @user.user_courses.create(number: "A", title: "TestA", taken: true)
      @user.user_courses.create(number: "B", title: "TestB", taken: true)
      @user.user_courses.create(number: "C", title: "TestC", taken: false)

      @a = Course.create(number: "A", title: "TestA")
      @b = Course.create(number: "B", title: "TestB")
      @b.prereqs.create(number: "A")
      @c = Course.create(number: "C", title: "TestC")
      @c.prereqs.create(number: "A")
      @c.prereqs.create(number: "B")
      @d = Course.create(number: "D", title: "TestD")
      @d.prereqs.create(number: "C")

      @prof1 = Professor.create(name: "Prof1")
      @prof1.professor_courses.create(number: "A", name: "TestA", rating: 5.5, term: "Fall 2014")
      @prof1.professor_courses.create(number: "B", name: "TestB", rating: 5.5, term: "Spring 2015")
      @prof2 = Professor.create(name: "Prof2")
      @prof2.professor_courses.create(number: "A", name: "TestA", rating: 7.0, term: "Spring 2015")
      @prof3 = Professor.create(name: "Prof3")
      @prof3.professor_courses.create(number: "C", name: "TestC", rating: 2.5, term: "Spring 2014")
      @prof3.professor_courses.create(number: "D", name: "TestD", rating: 1.5, term: "Fall 2014")
    end

    context "confirms user has taken a class" do
      it "should return true if user has taken course" do
        expect(@user.has_taken(Prereq.find_by(number: "A"))).to eq(true)
        expect(@user.has_taken(Prereq.find_by(number: "B"))).to eq(true)
      end
      it "should return false if user has not taken a course" do
        expect(@user.has_taken(Prereq.find_by(number: "C"))).to eq(false)
        expect(@user.has_taken(double(number: "D"))).to eq(false)
      end
    end
    context "confirms user wants to take a class" do
      it "should return true if user wants to take the class" do
        expect(@user.wants_to_take("C")).to eq(true)
      end
      it "should return false if user doesn't want to take the class" do
        expect(@user.wants_to_take("A")).to eq(false)
        expect(@user.wants_to_take("B")).to eq(false)
        expect(@user.wants_to_take("D")).to eq(false)
      end
    end
    context "check if user can take the class" do
      it "should return true if user can take the course" do
        expect(@user.can_take("C",false)).to eq(true)
      end
      it "should return false if user cannot take the course" do
        expect(@user.can_take("A",false)).to eq(false)
        expect(@user.can_take("B",false)).to eq(false)
        expect(@user.can_take("D",false)).to eq(false)
        expect(@user.can_take("A",true)).to eq(false)
        expect(@user.can_take("B",true)).to eq(false)
        expect(@user.can_take("C",true)).to eq(true)
        expect(@user.can_take("D",true)).to eq(true)
      end
    end

    ### NEW 
    # context "check if user can take the class if prereqs are ignored" do
    #   it "should return true regardless if user can take the course" do
    #     # set the ignore flag to true
    #     expect(@user.recommended_EECS_courses(true)).to eq({:possible_fall=>[], :backup_fall=>[], :possible_spring=>[], :backup_spring=>[]})
    #     expect(@user.can_take("A",true)).to eq(false)
    #     expect(@user.can_take("B",true)).to eq(true)
    #     expect(@user.can_take("C",true)).to eq(true)
    #     expect(@user.can_take("D",true)).to eq(true)
    #   end
    # end
    ### END
  end

  describe "Schedule recommendations" do
    before :each do
      User.destroy_all
      Course.destroy_all
      Professor.destroy_all
      UserCourse.destroy_all
      ProfessorCourse.destroy_all
      @test_user = User.create(first_name: "Test", last_name: "Test", uid: "123456", email: "Test@test.test")
      @a = Course.create(number: "A", title: "TestA")
      @b = Course.create(number: "B", title: "TestB")
      @c = Course.create(number: "C", title: "TestC")
      @prof1 = Professor.create(name: "Prof1")
      @prof2 = Professor.create(name: "Prof2")
      @prof3 = Professor.create(name: "Prof3")
      @prof1.courses.create(number: "A", name: "TestA", rating: 4.0, term: "SP16")
      @prof2.courses.create(number: "B", name: "TestB", rating: 3.0, term: "SP16")
      @prof3.courses.create(number: "C", name: "TestC", rating: 7.0, term: "SP16")
      @test_user.user_courses.create(number: "A", title: "TestA", taken: false)
      # @user.user_courses.create(number: "B", title: "TestB", taken: false)
      # @user.user_courses.create(number: "C", title: "TestC", taken: false)
      @draft_course_a = @a.draft_courses.create(professor: "Prof1", term: "FA16")
      @draft_course_b = @b.draft_courses.create(professor: "Prof2", term: "FA16")
      @draft_course_c = @c.draft_courses.create(professor: "Prof3", term: "FA16")
      @recommended_EECS_courses = @test_user.recommended_EECS_courses(false) # @ignore_flag = false
    end
    context "check the correct classes are recommended" do
      it "should recommend classes with better ratings" do
        expect(@recommended_EECS_courses[:backup_fall].select{|c| c[0].title == "TestC"}).not_to be_empty
      end
      it "should not recommend classes with worse ratings" do
        expect(@recommended_EECS_courses[:backup_fall].select{|c| c[0].title == "TestB"}).to be_empty
      end
    end
  end

  describe "Distinguishing different non-EECS awards" do
    before :each do
      User.destroy_all
      Course.destroy_all
      Professor.destroy_all
      UserCourse.destroy_all
      ProfessorCourse.destroy_all
      @test_user = User.create(first_name: "Test", last_name: "Test", uid: "123456", email: "Test@test.test")
      @a = Course.create(number: "ANTHROC125A", title: "Art")
      @b = Course.create(number: "ANTHRO189", title: "Music")
      @c = Course.create(number: "ASAMST172", title: "History")
      @d = Course.create(number: "IDX2017", title: "Dance")
      @cup = Professor.create({name: "Junko Habu", distinguished: true, distinguishedYear: 2016, category: "HUM", awarded: true})
      @dog = Professor.create({name: "Xin Liu", distinguished: false, category: "HUM", awarded: false})
      @cat = Professor.create({name: "Fae M. Ng", distinguished: true, distinguishedYear: 2014, category: "HUM", awarded: true})
      @lie = Professor.create({name: "Marcus Lee", distinguished: false, category: "HUM", awarded: true})
      @cup.courses.create({name: "Art", number: "ANTHROC125A", rating: 2, term: "FA16"})
      @dog.courses.create({name: "Music", number: "ANTHRO189", rating: 2, term: "FA16"})
      @cat.courses.create({name: "History", number: "ASAMST172", rating: 3, term: "FA16"})
      @lie.courses.create({name: "Dance", number: "IDX2017", rating: 4, term: "FA16"})
      @recommended_breadth_courses = @test_user.recommended_breadth_courses
      @courses_to_match = @recommended_breadth_courses.join(",")
    end
    context "recommend non-EECS courses" do
      it "should recommend courses from distinguished professors" do
        expect(@courses_to_match).to match(/ANTHROC125A/)
      end
      it "should recommend courses from awarded, non-distinguished professors" do
        expect(@courses_to_match).to match(/IDX2017/)
      end
    end
  end
end
