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
      answer =Answer.create_answer_to_question(request.request_parameters[:content], params[:question_id], user)
      if answer.valid?
        render json: answer, status: 201
      else
        render status: 422
      end
    end
  end

  def index
    answers = Answer.get_answers_for_question(params[:question_id])
    render json: answers
  end

  def destroy
    if (Answer.answer_exists(params[:id]))
      user = find_user_by_token
      if (Answer.is_checked(params[:id]))
        render json: {"Error": "No se puede borrar una respuesta marcada como correcta"}, status: 422
      elsif (Answer.is_author(user.id, params[:id]))
        if (Answer.delete_answer_to_question(params[:id], params[:question_id])) #si no se corresponde con la pregunta no la borra
          render json: "Borrada con exito"
        else
          render json: {"Error": "la respuesta que intenta borrar no es una respuesta de la pregunta enviada"}, status: 422
        end
      else
        render json: {"Error": "No se puede borrar una respuesta si no es el autor"}, status: 401
      end
    else
      render json: {"Error": "el id no se corresponde con el de ninguna respuesta"}, status: 422
    end
  end

  private :check_token, :find_user_by_token

end
