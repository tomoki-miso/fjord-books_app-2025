# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  def index
    @users = User.order(:id).page(params[:page]).per(2)
  end

  def show; end

  def set_user
    @user = User.find(params.expect(:id))
  end

  def user_params
    params.expect(user: %i[name email post_code address bio]).require(:user)
  end
end
