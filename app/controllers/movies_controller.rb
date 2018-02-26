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
    logger.debug("In the params[:rating] = #{params[:rating]}")
    logger.debug("In the session[:rating] = #{session[:rating]}")
    logger.debug("In the params[:sort] = #{params[:sort]}")
    logger.debug("In the session[:sort] = #{session[:sort]}")
    
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @movies = Movie.all
    
    if (params[:ratings] == nil and (session[:ratings] != nil))
        params[:ratings] = session[:ratings]
      #redirect_to movies_path(:filter => params[:filter], :sort => params[:sort], :ratings => params[:ratings]) 
    end
    if ((params[:sort] == nil) and (session[:sort] != nil))
        params[:sort] = session[:sort]
      #redirect_to movies_path(:filter => params[:filter], :sort => params[:sort], :ratings => params[:ratings]) 
    end 
    
    rate = params[:ratings]||session[:ratings]
    #redirect = false
    if(params[:ratings].present?)
      @movies = Movie.where(rating: params[:ratings].keys)
      session[:ratings] = params[:ratings]
    end
    params[:ratings] = session[:ratings]
    
    if(params[:sort] == 'title' or (params[:sort] == nil and session[:sort] == 'title'))
      @movies = Movie.where(rating: rate.keys).order(:title)
      session[:sort] = params[:sort]
    elsif(params[:sort] == 'release_date' or (params[:sort] == nil and session[:sort] == 'release_date'))
      @movies = Movie.where(rating: rate.keys).order(:release_date)
      session[:sort] = params[:sort]
    end
    params[:sort] = session[:sort]
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

  helper_method :hilite
  def hilite( header ); return 'hilite' if @sort == header; end
end
