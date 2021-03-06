class LikesController < ApplicationController
  before_action :current_user_must_be_like_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_like_user
    like = Like.find(params[:id])

    unless current_user == like.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @q = Like.ransack(params[:q])
    @likes = @q.result(:distinct => true).includes(:post, :user).page(params[:page]).per(10)

    render("likes/index.html.erb")
  end

  def show
    @like = Like.find(params[:id])

    render("likes/show.html.erb")
  end

  def new
    @like = Like.new

    render("likes/new.html.erb")
  end

  def create
    @like = Like.new

    @like.user_id = params[:user_id]
    @like.post_id = params[:post_id]

    save_status = @like.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/likes/new", "/create_like"
        redirect_to("/likes")
      else
        redirect_back(:fallback_location => "/", :notice => "Like created successfully.")
      end
    else
      render("likes/new.html.erb")
    end
  end

  def edit
    @like = Like.find(params[:id])

    render("likes/edit.html.erb")
  end

  def update
    @like = Like.find(params[:id])
    @like.post_id = params[:post_id]

    save_status = @like.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/likes/#{@like.id}/edit", "/update_like"
        redirect_to("/likes/#{@like.id}", :notice => "Like updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Like updated successfully.")
      end
    else
      render("likes/edit.html.erb")
    end
  end

  def destroy
    @like = Like.find(params[:id])

    @like.destroy

    if URI(request.referer).path == "/likes/#{@like.id}"
      redirect_to("/", :notice => "Like deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Like deleted.")
    end
  end
end
