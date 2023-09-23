class TracksController < ApplicationController
  before_action :check_and_refresh_token, only: [:show]

  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find_by(id: params[:id])
    @comments = @track.comments
    @comment = Comment.new
    @spotify_user = current_user.spotify_user
  end

  def new
    @song = RSpotify::Track.find(params[:track_id])
    @album = RSpotify::Album.find(params[:album_id])
    @track = Track.new
  end
  
  def edit
    @track = Track.find_by(id: params[:id])
  end

  def create
    @album, @song = fetch_spotify_album_and_song
  
    unless @album && @song
      return render :new
    end
  
    ActiveRecord::Base.transaction do
      @new_album = find_or_create_album
      @new_song = find_or_create_song(@new_album)
  
      @track = @new_song.tracks.new(track_params.merge(user: current_user))
      
      if @track.save
        redirect_to user_path(current_user)
      else
        render :new
      end
    end
  rescue ActiveRecord::Rollback
    render :new
  end
  

  def update
    @track = Track.find_by(id: params[:id])
    if @track.update(track_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end

  end

  def destroy
    @track = Track.find_by(id: params[:id])
    @user = @track.user
    if @track.destroy
      flash[:notice] = t('messages.delete_success', model: Track.model_name.human)
      redirect_to user_path(@user)
    else
      flash[:alert] = t('messages.delete_failure', model: Track.model_name.human)
      render 'users/show'
    end
  end
  

  def search_track
    @album = RSpotify::Album.find(params[:album_id])
    @tracks = @album.tracks
  end

  def search_album
    @searchartist = RSpotify::Artist.find(params[:artist_id])
    @albums = @searchartist.albums
  end

  def search_artist
    if params[:search].present?
    @searchartists = RSpotify::Artist.search(params[:search])
    end
  end

  private

  def track_params
    params.require(:track).permit(:start_time, :end_time, :section, :bpm, :instrument, :original_bpm, :duration )
  end

  def fetch_spotify_album_and_song
    album_code = params[:track][:album_code]
    song_code = params[:track][:song_code]
    
    album = RSpotify::Album.find(album_code)
    song = RSpotify::Track.find(song_code)
  
    [album, song]
  end
  
  def find_or_create_album
    Album.find_or_create_by(album_code: params[:track][:album_code]) do |album|
      album.title = @album.name
      album.artist_name = @album.artists.first.name
      album.album_image = @album.images[1]['url']
    end
  end
  
  def find_or_create_song(album)
    album.songs.find_or_create_by(song_code: params[:track][:song_code]) do |song|
      song.song_name = @song.name
      song.bpm = @song.audio_features.tempo
    end
  end
end
