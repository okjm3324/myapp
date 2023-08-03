class TracksController < ApplicationController

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  def index
  end

  def new
    @song = RSpotify::Track.find(params[:track_id])
    @track = Track.new
  end

  def show
  
  end

  def create
    @track = Track.new(track_params)
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
    gon.track_id = "56v8WEnGzLByGsDAXDiv4d"
  end

  

  private

  def track_params
    params.require(:track).permit(:start, :end, :section, :bpm, :instrument)
  end
end
