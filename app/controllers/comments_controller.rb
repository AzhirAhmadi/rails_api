class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]
  
  def index
    render json: article.comments.page(params[:page]).per(params[:per_page])
  end

  def create
    comment = article.comments.build(comment_params.merge(user: current_user))
    comment.save!
    render json: comment, status: :created, location: article
  rescue
    render json: comment, adaptor: :json_api,
      serializer: ErrorHandeler::ErrorSerializer,
      status: :unprocessable_entity
  end

  private
    def comment_params
      params.require(:data).require(:attributes).
      permit(:content) ||
      ActionController::Parameters.new
    end

    def article
      article = Article.find(params[:article_id])
    end
end
