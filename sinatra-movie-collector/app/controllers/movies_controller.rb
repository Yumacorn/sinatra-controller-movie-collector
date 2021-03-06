class MoviesController < ApplicationController

  get '/movies' do
    @movies = current_user.movies
    erb :"movies/movies.html"
  end

  post '/movies' do
    @movie = Movie.new
    @movie.title = params[:title]
    @movie.genre = params[:genre]
    @movie.release_year = params[:release_year]
    @movie.user_id = current_user.id
    if @movie.save # if you try to save an invalid ActiveRecord object, you get false
      redirect '/movies'
    else
      erb :"movies/add.html" # render as opposed to redirect, render whenever currnet request has data we need. # redirect if data is not required
    end
  end

  get '/movies/add' do
    #Check if user logged in
    if !logged_in?
      redirect "/login" # redirect if they aren't
    #
    else
      # "A new movie form"
      erb :"movies/add.html" # render if they are
    end
  end

  get '/movies/:id/edit' do
    #Check if user logged in
    if !logged_in?
      redirect "/login" # redirect if they aren't
    else
      @movie = current_user.movies.find(params[:id])
      erb :"movies/edit.html"
    end
  end

  patch '/movies/:id' do #edit action
    @movie = Movie.find_by_id(params[:id])
    original_title = @movie.title #save original settings
    original_genre = @movie.genre
    original_release_year = @movie.release_year

    @movie.title = params[:title]
    @movie.genre = params[:genre]
    @movie.release_year = params[:release_year]
    if !@movie.save # ActiveRecord validates true and allows save, render new edit page
      @movie.title = original_title
      @movie.genre = original_genre
      @movie.release_year = original_release_year
    end
    erb :"movies/edit.html"
  end


  delete '/movies/:id/delete' do #delete action
    @movie = Movie.find_by_id(params[:id])
    @movie.delete
    redirect to '/movies'
  end

end
