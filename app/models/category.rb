class Category < ActiveRecord::Base
  ABILITY = 'ability'
  INTEREST = 'interest'
  MOTIVATOR = 'motivator'
  CURRENT_EMPLOYER = 'current_employer'
  EMPLOYER = 'employer'
  DEGREE = 'degree'
  CAREER_PATH = 'career_path'

  LINKEDIN_CURRENT_EMPLOYER = "current_employer"
  LINKEDIN_SKILL = "skill"
  LINKEDIN_INTERESTS = "interests"
  LINKEDIN_EDUCATION = "education"
  LINKEDIN_CONNECTIONS = "connections"
  LINKEDIN_WORK_HISTORY = "work_history"
end
