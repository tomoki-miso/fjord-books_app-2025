# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  def index
    per_page_item = 2
    @users = User.order(:id).page(params[:page]).per(per_page_item)
  end

  def show; end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
