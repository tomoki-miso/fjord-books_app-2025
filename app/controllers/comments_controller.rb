# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create destroy]

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
        format.turbo_stream
      else
        format.html { render parent_show_template, status: :unprocessable_entity }
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])

    redirect_to @commentable, alert: t('controllers.common.permission_denied') unless @comment.user == current_user

    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to @commentable, status: :see_other }
      format.turbo_stream
    end
  end

  private

  def set_commentable
    @commentable = if params[:book_id]
                     Book.find(params[:book_id])
                   elsif params[:report_id]
                     Report.find(params[:report_id])
                   end
  end

  def parent_show_template
    "#{@commentable.class.name.tableize}/show"
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
