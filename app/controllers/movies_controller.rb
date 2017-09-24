class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie::Ratings
    @redirect    = false
    
    if params[:ratings] != nil
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings] != nil
      @ratings  = session[:ratings]
      @redirect = true
    else 
      @ratings = @all_ratings
    end
      
    if params[:field] != nil
      @field = params[:field]
      session[:field] = @field
    elsif session[:field] != nil
      @field = session[:field]
      @redirect = true
    else
      @field = "id"
    end
    
    if @redirect == true
      flash.keep
      redirect_to movies_path(:field => @field, :ratings => @ratings)
    else
      @movies = Movie.order(@field).where(rating: @ratings.keys)
    end
    session.clear
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
