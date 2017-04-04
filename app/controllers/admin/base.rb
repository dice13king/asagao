class Admin::Base < ApplicationController
  before_action :admin_login_required

  private
  def admin_login_required
    raise forbidden unless current_member.try(:administrator?)
  end
end
