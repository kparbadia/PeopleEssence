class ApplicationController < ActionController::Base
  protect_from_forgery
  include FaceboxRender
  def after_sign_in_path_for(resource)
    "/questionnaires"
  end
end
