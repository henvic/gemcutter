class ProfilesController < ApplicationController

  before_filter :redirect_to_root, :unless => :signed_in?

  def edit
  end
  def show
  end

  def update
    if current_user.update_attributes(params[:user])
      if current_user.email_reset
        sign_out
        flash[:notice] = "You will receive an email within the next few minutes. " <<
                         "It contains instructions for reconfirming your account with your new email address."
        redirect_to root_path
      else
        flash[:notice] = "Your profile was updated."
        redirect_to edit_profile_path
      end
    else
      render :edit
    end
  end
end
