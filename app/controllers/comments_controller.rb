class CommentsController < ApplicationController
   
   skip_before_action :get_latest_news
   
   def list
      @comment = Comment.new
      @comments = Comment.where("created_at > ?", Date.today - 30).order(created_at: :desc)
   end
   
   def create
      Comment.create( params[:comment] )
      redirect_to(controller: 'comments', action: 'list')
   end
end