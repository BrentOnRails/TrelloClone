class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    

    if !!(@user.username =~ /Guest\d/)
           # remove all other demo users
      guests = User.where('username LIKE ?', 'Guest%').all
      if guests
        guests.each do |guest|
          if guest.updated_at < 30.seconds.ago
            guest.delete
          end
        end 
        @user.username = "Guest" + (User.count + 1).to_s
        @user.email = @user.username + "@foobar.com"
      end
    end

    if @user.save
      login!(@user)
      @user.guest_data if !!(@user.username =~ /Guest\d/)
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
