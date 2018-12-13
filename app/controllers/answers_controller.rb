class AnswersController < ApplicationController

  before_action :check_token, only: [:create, :destroy]

  def check_token
    render json: {"Error": "El token proporcionado para autenticar al usuario es invalido"}, status: 401 unless User.check_token(request.headers["X-QA-Key"])
  end

  def find_user_by_token
    token = request.headers["X-QA-Key"]
    User.find_by_token(token)
  end

  def create
    if (Question.is_answered(params[:question_id]))
      render json: {"Error": "La pregunta está resuelta"}, status: 422
    else
      user = find_user_by_token
      Answer.create_answer_to_question(request.request_parameters[:content], params[:question_id], user)
    end
  end


  private :check_token, :find_user_by_token

end
