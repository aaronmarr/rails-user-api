class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]
  before_action :authenticate, only: [:destroy] 

  AUTH_TOKEN = 'super-secret!'

  def create
    @user = User.create!(user_params)
  
    json_response(@user, :created)
  end

  def show
    json_response(@user)
  end

  def destroy
    @user.destroy

    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def authenticate
    authenticate_token || json_response('Bad credentials', :unauthorized)
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      token == AUTH_TOKEN
    end
  end
end
