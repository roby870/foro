class UsersController < ApplicationController

  def create

    user = User.create_user(request.request_parameters[:username], request.request_parameters[:password], request.request_parameters[:screen_name], request.request_parameters[:email])

    if user.valid?
      render status: 201
    else
      render json: user.errors, status: 422
    end
  end

end
