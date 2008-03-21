class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  session :session_key => '_db2oncampus_session_id'
  helper :all
  filter_parameter_logging 'password', 'email'

end