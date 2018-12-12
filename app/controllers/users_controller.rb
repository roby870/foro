class UsersController < ApplicationController

  

  def create

    user = User.create(username: request.request_parameters[:username], password: request.request_parameters[:password], screen_name: request.request_parameters[:screen_name], email: request.request_parameters[:email])

    if user.valid?
      render status: 201
    else
      render json: user.errors, status: 422
    end
  end

end
