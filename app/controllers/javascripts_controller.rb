class JavascriptsController < ApplicationController
  def dynamic_organizations
    @organizations = Organization.find :all
  end
end
