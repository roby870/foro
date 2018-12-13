require 'securerandom'
require 'date'
require 'time'
#require 'action_view'
#require 'action_view/helpers'
#include ActionView::Helpers::DateHelper

class SessionsController < ApplicationController

  def create
    if user = User.authenticate(params[:username], params[:password])
      #puts distance_of_time_in_words_to_now(u.token_created_at)
      token = SecureRandom.uuid.gsub(/\-/,'')
      User.save_token(user, token)
      response.headers["Content-Type"] = "application/json"
      response.headers["X-QA-Key"] = token
      #render response.body no funciona
      render json: user, status:200
    else
      render json: {"Error": "Los datos proporcionados para atuenticar al usuario son incorrectos"}, status: 422
    end
  end



end
