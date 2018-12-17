require 'securerandom'
require 'date'
require 'time'
require 'json'

class SessionsController < ApplicationController

  def create
    if user = User.authenticate(params[:username], params[:password])
      token = SecureRandom.uuid.gsub(/\-/,'')
      User.save_token(user, token)
      render json: JSON.pretty_generate({"data": [{
          "type":"users",
          "id":user.id,
          "attributes":{
                "username":user.username,
                "screen_name":user.screen_name,
                "email":user.email,
                "token":user.token
          }
      }
      ]
      }), status:200
    else
      render json: JSON.pretty_generate({"errors":"Los datos proporcionados para autenticar al usuario son incorrectos"}), status: 422
    end
  end



end
