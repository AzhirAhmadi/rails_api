class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]
  
  def index
    render json: article.comments.page(params[:page]).per(params[:per_page])
  end

  def create
    comment = article.comments.build(comment_params.merge(user: current_user))

    if comment.save
      render json: comment, status: :created, location: article
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end
  def article
    article = Article.find(params[:article_id])
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
