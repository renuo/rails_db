module RailsDb
  class ApplicationController < ActionController::Base
    helper :all
    helper_method :per_page

    before_action :verify_access
    before_action :set_current_connection

    if RailsDb.http_basic_authentication_enabled
      http_basic_authenticate_with name: RailsDb.http_basic_authentication_user_name,
                                   password: RailsDb.http_basic_authentication_password
    end

    private

    def verify_access
      result = RailsDb.verify_access_proc.call(self)
      redirect_to('/', error: 'Access Denied', status: 401) unless result
    end

    def set_current_connection
      RailsDb.primary_database = params[:primary_database] || RailsDb.primary_database
    end

    def per_page
      params[:per_page] || session[:per_page]
    end

  end
end
