class TopController < ApplicationController
  skip_before_action :require_login, only: %i[top] 
  def top;end
  def index
  end
end
