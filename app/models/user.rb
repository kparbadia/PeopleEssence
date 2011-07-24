class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy

  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships

  has_many :employments
  has_many :questionnaires
  has_many :user_details

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  TYPE_REGISTERED = 'Registered'
  TYPE_UNREGISTERED = 'Unregistered'
  TYPE_PROVIDER_FACEBOOK = 'Facebook'
  TYPE_PROVIDER_LINKEDIN = 'Linkedin'

  scope :registered, :conditions => "user_type = '#{TYPE_REGISTERED}'"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :rememberable, :trackable, :validatable, :omniauthable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def apply_omniauth(omniauth)
    authentications.build(
      :provider => omniauth['provider'],
      :uid      => omniauth['uid'],
      :token    => omniauth['credentials']['token'],
      :secret   => omniauth['credentials']['secret']
    )
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super()
  end

  #publish to facebook and twitter

  def full_name
    "#{first_name} #{last_name}"
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token).fetch
    #fb_user ||= FbGraph::User.new('me', :access_token => self.authentications.find_by_provider('facebook').token).fetch    
  end

  def twitter
    unless @twitter_user
      provider = self.authentications.find_by_provider('twitter')
      @twitter_user = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret) rescue nil
    end
    @twitter_user
  end

  def publish(text, feed_name, provider)
    begin
      case provider
      when 'facebook' then facebook.feed!(:message => text, :name => feed_name)
        #when 'twitter' then twitter.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => text)
      when 'twitter' then twitter.update(text)
      end
    rescue Exception => ex
      logger.error("Error pushing to FB and twitter: #{ex.message}")
    end    
  end

  def matched_jobs
    interests = self.user_details.find(:all, :conditions => ["category = ?", Category::INTEREST])
    interest_names = interests.collect(&:linkedin_value)
    jobs = Job.find(:all, :include => :job_details, :conditions => ["job_details.category = ? and job_details.reference in (?)", Category::INTEREST, interest_names])

    return jobs
    return Job.all
  end
end
