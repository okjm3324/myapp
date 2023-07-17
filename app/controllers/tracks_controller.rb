class TracksController < ApplicationController
  def index
  end

  def new
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

  private

  def track_params
    params.require(:track).permit(:start, :end, :section, :bpm, :instrument)
  end
end
