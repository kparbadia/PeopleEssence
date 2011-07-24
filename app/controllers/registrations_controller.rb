class RegistrationsController < Devise::RegistrationsController 
  def new
    build_resource({})
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
    #  respond_with_navigational(resource){ render_with_scope :new }
  end


  def create
    begin
      super()
      session[:omniauth] = nil unless @user.new_record?
    rescue Exception => ex
      logger.error "Exception in registration: #{ex.message}"
      logger.error ex.backtrace.join("\n")
    end
  end
  private
  def build_resource(*args)
    super()
    if(session[:omniauth])
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end    
  end
end