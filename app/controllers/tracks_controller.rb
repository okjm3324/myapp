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
    @track = Track.find_by(id: params[:id])
    @comments = @track.comments
    @comment = Comment.new
  
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

  def edit
    @track = Track.find_by(id: params[:id])
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
      flash[:notice] = 'トラックを削除しました。'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'トラックの削除に失敗しました。'
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

  def play
    #gon.access_token = current_user.access_token
   # gon.access_token = session[:access_token]
    #gon.track_id = "56v8WEnGzLByGsDAXDiv4d"

    user = RSpotify::User.find(current_user.user_code)
    player = RSpotify::Player.new(user)

    track_uri = 'spotify:track:56v8WEnGzLByGsDAXDiv4d'
    device_id = '9bca8a3a33bb1779c6ea9d7cb2e7903d55a0f75a'
    player.play_track(device_id, track_uri)

    sleep 5 # Wait for 5 seconds

    position_ms = 10000
    player.seek(position_ms)
  end

  def play_and_seek
    user = RSpotify::User.find(current_user.user_code)
    player = user.player

    track_uri = 'spotify:track:<TRACK_ID>'
    player.play_track(nil, track_uri)

    sleep 5 # Wait for 5 seconds

    position_ms = 10000
    player.seek(position_ms)

    # Add any additional logic or responses you need here
  end
  

  private

  def track_params
    params.require(:track).permit(:start, :end, :section, :bpm, :instrument, :original_bpm, :duration )
  end
end
