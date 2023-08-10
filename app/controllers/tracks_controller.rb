class TracksController < ApplicationController

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  def index
  end

  def new
    @song = RSpotify::Track.find(params[:track_id])
    @album = RSpotify::Album.find(params[:album_id])
    @track = Track.new
  end

  def show
  
  end

  def create
    album_code = params[:track][:album_code]
    song_code = params[:track][:song_code]
  
    ActiveRecord::Base.transaction do
      @album = RSpotify::Album.find(album_code)
      @song = RSpotify::Track.find(song_code)
  
      return render :new unless @album && @song
  
      title = @album.name
      artist = @album.artists.first.name
  
      # アルバムがすでに存在するかチェック
      @new_album = Album.find_or_create_by(album_code: album_code) do |album|
        album.title = title
        album.artist_name = artist
      end
  
      song_name = @song.name
      bpm = @song.audio_features.tempo
  
      # 曲がすでに存在するかチェック
      @new_song = @new_album.songs.find_or_create_by(song_code: song_code) do |song|
        song.song_name = song_name
        song.bpm = bpm
      end
  
      @track = @new_song.tracks.new(track_params.merge(user: current_user)) # カレントユーザーと紐付け
  
      if @track.save
        redirect_to user_path(current_user)
      else
        render :new
      end
    end
  end
  

  def update
  end

  def destroy
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

  def play
    gon.access_token = session[:access_token]
   # gon.access_token = session[:access_token]
    gon.track_id = "56v8WEnGzLByGsDAXDiv4d"
  end

  

  private

  def track_params
    params.require(:track).permit(:start, :end, :section, :bpm, :instrument, :original_bpm, :duration )
  end
end
