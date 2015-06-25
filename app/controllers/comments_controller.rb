class CommentsController < ApplicationController
   def list
      @comment = Comment.new
      @comments = Comment.where("created_at > ?", Date.today - 7).order(created_at: :desc)
   end
   
   def create
      Comment.create( params[:comment] )
      redirect_to(controller: 'comments', action: 'list')
   end
end