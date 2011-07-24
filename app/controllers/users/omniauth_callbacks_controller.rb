class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook    
    authenticate_omniauth_user()
  end

  def twitter    
    authenticate_omniauth_user()
  end

  def linked_in    
    authenticate_omniauth_user()
  end

  def failure
    puts("Omniauth failure callback")
    logger.info("Omniauth failure callback")
    flash[:notice] = "Omniauth failure callback"
    @auth = env["omniauth.auth"]
    render(:action => "index")
  end

  private

  def authenticate_omniauth_user
    begin
      logger.debug 'I am in create of authentication'
      omniauth =  request.env["omniauth.auth"]
      logger.debug 'After calling omniauth'
      authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'] )
      logger.debug 'After calling omniauth'
      if(authentication.present?)
        sign_in_and_redirect(:user, authentication.user)
        flash[:notice] = 'Signed in successfuly'
      elsif(current_user.present?)
        current_user.authentications.create!(:provider => omniauth['provider'],
          :uid => omniauth['uid'],
          :token    => omniauth['credentials']['token'],
          :secret   => omniauth['credentials']['secret'])
        if(omniauth['provider'] == 'facebook')
          token =  current_user.authentications.find_by_provider('facebook').token
        elsif(omniauth['provider'] == 'linked_in')
          token =  current_user.authentications.find_by_provider('linked_in').token
          secret =  current_user.authentications.find_by_provider('linked_in').secret
        end
        flash[:notice] = 'Authentications successful'
        redirect_to authentications_url
      else
        user = User.new()
        user.apply_omniauth(omniauth)
        if(user.save)
          sign_in_and_redirect(:user, user)
          flash[:notice] = 'Signed in successfuly'
        else       
          logger.debug omniauth#.except('extra')
          if(omniauth['provider'] == 'facebook')
            user.email = omniauth['user_info']['email']
            # user.fb_id = omniauth['uid']
            user.provider_id= omniauth['uid']
            nonreg_user=User.find_by_provider_id(omniauth['uid'])
            if(nonreg_user.nil?)
              user.password = Devise.friendly_token
              user.user_type = User::TYPE_REGISTERED
              user.provider = User::TYPE_PROVIDER_FACEBOOK
              user.user_name = omniauth['user_info']["name"]
              user.first_name = omniauth['user_info']["first_name"]
              user.last_name = omniauth['user_info']["last_name"]
              user.save
              employer_name = 'No company name'
              employment_position = 'No job info'
              joining_date = nil
              begin
                employer_name = omniauth['extra']['user_hash']['work'][0]['employer']["name"] != '' ? omniauth['extra']['user_hash']['work'][0]['employer']["name"] : 'No company name'
                employment_position = omniauth['extra']['user_hash']['work'][0]['position']["name"] != '' ? omniauth['extra']['user_hash']['work'][0]['position']["name"] : 'No job info'
                joining_date = omniauth['extra']['user_hash']['work'][0]['start_date'] != '' ? omniauth['extra']['user_hash']['work'][0]['start_date'] : nil
              rescue
              end
              
              token = user.authentications.find_by_provider('facebook').token
              user.employments.build(:company =>  employer_name, :position => employment_position, :joining_date => joining_date)
              sign_in_and_redirect(:user, user)
            else
              nonreg_user.apply_omniauth(omniauth)
              nonreg_user.password = Devise.friendly_token
              nonreg_user.user_type=User::TYPE_REGISTERED
              nonreg_user.email = omniauth['user_info']['email']
              #nonreg_user.provider = User::TYPE_PROVIDER_FACEBOOK
              #nonreg_user.user_name = omniauth['user_info']["name"]
              nonreg_user.save
              token = nonreg_user.authentications.find_by_provider('facebook').token
              sign_in_and_redirect(:user, nonreg_user)
            end
            
            flash[:notice] = 'Signed in successfuly'
            return

          elsif(omniauth['provider'] == 'linked_in')
            user.email = "#{omniauth['uid']}@linkedin.com"
            user.provider_id= omniauth['uid']
            nonreg_user=User.find_by_provider_id(omniauth['uid'])
            if(nonreg_user.nil?)
              begin
                user.password = Devise.friendly_token
                user.user_type = User::TYPE_REGISTERED
                user.provider = User::TYPE_PROVIDER_LINKEDIN
                user.user_name = omniauth['user_info']["name"]
                user.first_name = omniauth['user_info']["first_name"]
                user.last_name = omniauth['user_info']["last_name"]
                user.save!
              rescue Exception => ex
                logger.error "Error saving user: #{ex.message}"
              end
              token = user.authentications.find_by_provider('linked_in').token
              secret = user.authentications.find_by_provider('linked_in').secret
              keys = YAML.load_file("#{Rails.root}/config/keys.yml")
              linkedin_token = keys["linkedid_token"]
              linkedin_secret_key = keys["linkedin_secret_key"]
              client = LinkedIn::Client.new(linkedin_token, linkedin_secret_key)
              client.authorize_from_access( token,  secret)
              user_profile_info = client.profile(:id => omniauth['uid'], :fields => "positions")
              current_company_name = ""
              company_names = []
              if(user_profile_info.positions.present?)
                current_company = user_profile_info.positions.detect(){|p| p.is_current}
                current_company_name = current_company.company.name if(current_company.present?)
                company_names = user_profile_info.positions.collect(){|p| p.company.name}

                user.user_details.create(:linkedin_attribute => Category::LINKEDIN_CURRENT_EMPLOYER,
                  :linkedin_value => current_company_name, :category => Category::CURRENT_EMPLOYER, :weight => 1) if(current_company_name.present?)
                company_names.each do |company_name|
                  user.user_details.create(:linkedin_attribute => Category::LINKEDIN_WORK_HISTORY,
                    :linkedin_value => company_name, :category => Category::EMPLOYER, :weight => 1)
                end
              end
              skills = client.profile(:id => omniauth['uid'], :fields => "skills").skills
              skillnames = skills.present? ? skills.collect(){|s| s.name} : []
              skillnames.each do |skill_name|
                user.user_details.create(:linkedin_attribute => Category::LINKEDIN_SKILL,
                  :linkedin_value => skill_name, :category => Category::ABILITY, :weight => 1)
              end

              interest_csv = client.profile(:id => omniauth['uid'], :fields => "interests").interests
              interests = interest_csv.present? ? interest_csv.split(",") : []
              interests.each do |interest|
                user.user_details.create(:linkedin_attribute => Category::LINKEDIN_INTERESTS,
                  :linkedin_value => interest, :category => Category::INTEREST, :weight => 1)
              end

              educations = client.profile(:id => omniauth['uid'], :fields => "educations").educations
              degrees = educations.present? ? educations.collect(){|e| e.degree} : []
              degrees.each do |degree|
                user.user_details.create(:linkedin_attribute => Category::LINKEDIN_EDUCATION,
                  :linkedin_value => degree, :category => Category::DEGREE, :weight => 1)
              end
              
              sign_in_and_redirect(:user, user)
            else
              nonreg_user.apply_omniauth(omniauth)
              nonreg_user.password = Devise.friendly_token           
              nonreg_user.user_type=User::TYPE_REGISTERED
              nonreg_user.save
              token = nonreg_user.authentications.find_by_provider('linked_in').token
              secret = nonreg_user.authentications.find_by_provider('linked_in').secret
              sign_in_and_redirect(:user, nonreg_user)
            end
            flash[:notice] = 'Signed in successfuly'
            return
          elsif(omniauth['provider'] == 'twitter')
            user.email = "#{omniauth['uid']}@twitter.com"
          end          
          user.password = Devise.friendly_token
          # user.skip_confirmation! # Sets confirmed_at to Time.now, activating the account
          user.user_type=User::TYPE_REGISTERED
          user.save
          sign_in_and_redirect(:user, user)
          flash[:notice] = 'Signed in successfuly'
          #redirect_to new_user_registration_url
          
        end
      end
    rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
    end
  end
end
