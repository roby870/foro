require 'json'

class UsersController < ApplicationController

  def create

    user = User.create_user(request.request_parameters[:username], request.request_parameters[:password], request.request_parameters[:screen_name], request.request_parameters[:email])

    if user.valid?
      render json: JSON.pretty_generate({"data": [{
          "type":"users",
          "id":user.id,
          "attributes":{
                "username":user.username,
                "screen_name":user.screen_name,
                "email":user.email
          }
      }
      ]
      }),status: 201
    else
      render json: JSON.pretty_generate({"errors": [user.errors.as_json]}), status: 422
    end
  end

end
