#Rails.application.config.middleware.use OmniAuth::Builder do
#  if(Rails.env == 'development')
#    provider :twitter, 'bcjVOadd9OE0qtfLKwkw', 'Ayi358BqXAfE4EZtETReOaaOFxer0vb0bAD6NSQb0'
#    provider :facebook, '176924659023806', '0b9a39f5ea1dcf863842c479631cc3fa', { :scope => 'user_about_me,user_activities,user_birthday,user_education_history,user_events,user_groups,user_hometown,user_interests,user_likes,user_location,user_notes,user_online_presence,user_photo_video_tags,user_photos,user_relationships,user_relationship_details,user_religion_politics,user_status,user_videos,user_website,user_work_history,email,read_friendlists,read_insights,read_mailbox,read_requests,read_stream,xmpp_login,ads_management,user_checkins,publish_stream,create_event,rsvp_event,sms,offline_access,publish_checkins,manage_pages,friends_about_me,friends_activities,friends_birthday,friends_education_history,friends_events,friends_groups,friends_hometown,friends_interests,friends_likes,friends_location,friends_notes,friends_online_presence,friends_photo_video_tags,friends_photos,friends_relationships,friends_relationship_details,friends_religion_politics,friends_status,friends_videos,friends_website,friends_work_history,manage_friendlists,friends_checkins' }
#    provider :linked_in, 'j8s-GQMgOdp8pIns3i5SlXspR5K6d6APJUfKdx0KREkOr8VvCfRSAiNCrT_IIqYy', '2e8zU7cO3-QMbWUJaeryjaUhLK90cuV4pBPOc_D_3_bT8LUYbUjmnHtYpb2wCgEE'
#  elsif(Rails.env == 'test')
#    provider :twitter, 'eM339ZpF6MdFDTDPu5xD8Q', '9rUtKqIV0mNj6oJDWpzml9UAAKCYMY2Di3aECQvRPTE'
#    provider :facebook, '119529928127880', '087443fa97b48e3e077acdf68ad838b3', { :scope => 'email, status_update, publish_stream' }
#    provider :linked_in, 'j8s-GQMgOdp8pIns3i5SlXspR5K6d6APJUfKdx0KREkOr8VvCfRSAiNCrT_IIqYy', '2e8zU7cO3-QMbWUJaeryjaUhLK90cuV4pBPOc_D_3_bT8LUYbUjmnHtYpb2wCgEE'
#  end
#end

Twitter.configure do |config|
  if(Rails.env == 'development')
    config.consumer_key = 'bcjVOadd9OE0qtfLKwkw'
    config.consumer_secret = 'Ayi358BqXAfE4EZtETReOaaOFxer0vb0bAD6NSQb0'
    config.oauth_token = '19847830-lL0SpQ0JWBMgslQ1fZuOqfhZUpMxXGx069rDoLJrb'
    config.oauth_token_secret = 'srzvI2wDHELbC5aKAanFRTs7vMsYOniMccaA8jtbKEU'
  elsif(Rails.env == 'test')
    config.consumer_key = 'eM339ZpF6MdFDTDPu5xD8Q'
    config.consumer_secret = '9rUtKqIV0mNj6oJDWpzml9UAAKCYMY2Di3aECQvRPTE'
    config.oauth_token = '19847830-NP9YoCQ31ZXkkRozj12TZVQx4PV2BAxRTwEUYSnLq'
    config.oauth_token_secret = 'l2kMdUWXiA5SSqTyffqlKKIrcRi260EJxmaBHcJlG3Q'
  end  
end