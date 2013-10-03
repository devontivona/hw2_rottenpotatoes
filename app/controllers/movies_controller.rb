class MoviesController < ApplicationController

  def show
    @movie = Movie.find(params[:id])
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false

    if params.has_key? :ratings
      @current_ratings = params[:ratings].keys
    else
      redirect = true
      @current_ratings = session.has_key?(:ratings) ? session[:ratings] : @all_ratings
    end

    if params.has_key? :sort
      @sort_order = params[:sort]
    elsif session.has_key? :sort
      redirect, @sort_order = true, session[:sort]
    else
      @sort_order = nil
    end

    if redirect
      flash.keep
      ratings = @current_ratings.inject({}) { |h, r| h[r] = 1; h }
      redirect_to movies_path(ratings: ratings, sort: @sort_order)
    else
      session[:ratings], session[:sort] = @current_ratings, @sort_order
      @movies = Movie.where("rating IN (?)", @current_ratings).order(@sort_order)
    end
  end

  def new
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
