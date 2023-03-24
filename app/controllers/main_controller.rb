class MainController < ApplicationController
  def index
    render json: { status: 'OK', timestamp: Time.now.to_i }
  end
end
