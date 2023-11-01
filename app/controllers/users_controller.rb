class UsersController < ApplicationController
  before_action :set_user, only: [:show, :liked, :feed, :followers, :following]

  def show
  end

  def liked
  end

  def feed
  end

  def followers
  end

  def following
  end

  private

  def set_user
    @user = User.find_by!(username: params.fetch(:username))
  end
  
end
