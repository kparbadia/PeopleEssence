# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Question.create(:title => "Do you like working with numbers", :category => Category::INTEREST, :reference => CategoryReference::QA)
Question.create(:title => "Would you like being the captain or owner of a sports team", :category => Category::INTEREST, :reference => CategoryReference::EC)
Question.create(:title => "Do you give frequent presentations", :category => Category::ABILITY, :reference => CategoryReference::OC)
Question.create(:title => "Do you find it difficult to say no to a salesman", :category => Category::ABILITY, :reference => CategoryReference::ASSERTIVENESS)
Question.create(:title => "Do you mentor", :category => Category::MOTIVATOR, :reference => CategoryReference::ALTRUISM)

job = Job.create(:title => "job1")
job.job_details.create(:category => Category::INTEREST, :reference => CategoryReference::QA, :weight => 2)
job.job_details.create(:category => Category::INTEREST, :reference => CategoryReference::EC, :weight => 2)
job.job_details.create(:category => Category::ABILITY, :reference => CategoryReference::OC, :weight => 2)
job.job_details.create(:category => Category::MOTIVATOR, :reference => CategoryReference::ALTRUISM, :weight => 2)

job = Job.create(:title => "job2")
job.job_details.create(:category => Category::INTEREST, :reference => CategoryReference::QA, :weight => 2)
job.job_details.create(:category => Category::MOTIVATOR, :reference => CategoryReference::ALTRUISM, :weight => 2)

job = Job.create(:title => "job3")
job.job_details.create(:category => Category::ABILITY, :reference => CategoryReference::ASSERTIVENESS, :weight => 2)
job.job_details.create(:category => Category::INTEREST, :reference => "Reading books", :weight => 2)

#u.user_details.create(:linkedin_attribute => Category::LINKEDIN_CURRENT_EMPLOYER, :linkedin_value => 'test1', :category => Category::CURRENT_EMPLOYER, :reference => CategoryReference::QA, :weight => 1)