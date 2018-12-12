class QuestionsController < ApplicationController

before_action :check_token, only: [:create]

def check_token
  render json: {"Error": "El token proporcionado para autenticar al usuario es invalido"}, status: 422 unless User.check_token(request.headers["X-QA-Key"])
end

def create
  token = request.headers["X-QA-Key"]
  user = User.find_by(token: token)
  Question.create(title: request.request_parameters[:title], description:request.request_parameters[:description], user_id: user.id)
  render json: {"Operacion exitosa": "pregunta creada"}, status: 201
end

end
