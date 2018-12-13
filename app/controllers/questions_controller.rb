class QuestionsController < ApplicationController

before_action :check_token, only: [:create, :update, :resolve]

  def check_token
    render json: {"Error": "El token proporcionado para autenticar al usuario es invalido"}, status: 401 unless User.check_token(request.headers["X-QA-Key"])
  end

  def find_user_by_token
    token = request.headers["X-QA-Key"]
    User.find_by_token(token)
  end

  def create
    user = find_user_by_token
    Question.create_question(request.request_parameters[:title], request.request_parameters[:description], user.id)
    render json: {"Operacion exitosa": "pregunta creada"}, status: 201
  end

  def update
    user = find_user_by_token
    if question = Question.check_user_has_question(user, params[:id])
      if (request.request_parameters[:title] != nil)
        Question.update_title(request.request_parameters[:title], question)
        if (request.request_parameters[:description] != nil)
          Question.update_description(request.request_parameters[:description], question)
        end
      elsif (request.request_parameters[:description] != nil)
        Question.update_description(request.request_parameters[:description], question)
      else
          render json: {"error": "debe enviar title y/o description a modificar"}, status: 422
      end
      render json: {"Operacion exitosa": "pregunta modificada"}, status: 200
    else
      render json: {"eror": "no tiene permiso para modificar la pregunta"}, status: 401
    end
  end

  def resolve
    user = find_user_by_token
    if question = Question.check_user_has_question(user, params[:id])
      if (Answer.is_answer_of(request.request_parameters[:answer_id],params[:id]))
        Answer.mark_as_correct(request.request_parameters[:answer_id])
        Question.mark_as_resolved(params[:id])
      else
        render json: {"eror": "la pregunta y la respuesta indicadas en los parametros no se corresponden"}, status: 422
      end
    else
      render json: {"eror": "no tiene permiso para modificar la pregunta como respondida"}, status: 401
    end
  end

  private :check_token, :find_user_by_token

end
