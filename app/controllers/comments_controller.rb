# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @comments = @commentable.comments
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
end
