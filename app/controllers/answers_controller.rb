class AnswersController < ApplicationController

  before_action :check_token, only: [:create, :destroy]

  def check_token
    if request.headers["X-QA-Key"].nil?
      render json: JSON.pretty_generate({"errors": ["error":"No se ha enviado el token de autenticacion"]}), status: 422
    else
      render json: JSON.pretty_generate({"errors": ["error":"El token proporcionado para autenticar al usuario es invalido"]}), status: 401 unless User.check_token(request.headers["X-QA-Key"])
    end
  end

  def find_user_by_token
    token = request.headers["X-QA-Key"]
    User.find_by_token(token)
  end

  def create
    if (Question.is_answered(params[:question_id]))
      render json: JSON.pretty_generate({"errors": ["error": "La pregunta está resuelta"]}), status: 422
    else
      user = find_user_by_token
      answer =Answer.create_answer_to_question(request.request_parameters[:content], params[:question_id], user)
      if answer.valid?
        render status: 201
      else
        render json: JSON.pretty_generate({"errors": [answer.errors.as_json]}), status: 422
      end
    end
  end

  def index
    answers = Answer.get_answers_for_question(params[:question_id])
    answers_json =  answers.collect {|answer| {
        "type":"answers",
        "id":answer.id,
        "attributes":{
              "content":answer.content,
              "checked": answer.checked,
              "created_at":answer.created_at
        },
        "relationships": {
                "author": {
                    "data": {
                          "type": "users",
                          "id": answer.user_id
                    }
                },
                "question": {
                    "data":{
                        "type": "questions",
                        "id": answer.question_id
                    },
                    "links": {
                        "related": "http://0.0.0.0:3000/questions/#{answer.question_id}"
                    }
                }
        }
      }
    }
    render json:  JSON.pretty_generate({"data": answers_json}),status: 200
  end

  def destroy
    if (Answer.answer_exists(params[:id]))
      user = find_user_by_token
      if (Answer.is_checked(params[:id]))
        render json: JSON.pretty_generate({"errors": ["error": "No se puede borrar una respuesta marcada como correcta"]}), status: 422
      elsif (Answer.is_author(user.id, params[:id]))
        if (Answer.delete_answer_to_question(params[:id], params[:question_id])) #si no se corresponde con la pregunta no la borra
          render status: 200
        else
          render json: JSON.pretty_generate({"errors": ["error": "la respuesta que intenta borrar no es una respuesta de la pregunta enviada"]}), status: 422
        end
      else
        render json: JSON.pretty_generate({"errors":  ["error": "No se puede borrar una respuesta si no es el autor"]}), status: 401
      end
    else
      render json: JSON.pretty_generate({"errors":  ["error": "el id no se corresponde con el de ninguna respuesta"]}), status: 422
    end
  end

  private :check_token, :find_user_by_token

end
