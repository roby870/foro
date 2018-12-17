require 'json'

class QuestionsController < ApplicationController

before_action :check_token, only: [:create, :update, :resolve, :destroy]

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

  def question_api_json(question)
    question_json = { "data": [ {
        "type":"questions",
        "id":question.id,
        "attributes":{
              "title":question.title,
              "description": question.description,
              "status":question.status,
              "created_at": question.created_at,
              "updated_at": question.updated_at
        },
        "relationships": {
              "author": {
                  "data": {
                        "type": "users",
                        "id": question.user_id
                  }
              },
              "answers": {
                  "links": {
                      "related": "http://0.0.0.0:3000/questions/#{question.id}/?included=true"
                  }
              }
        }
    } ] }
  end

  def questions_api_json(questions)
    questions_json = (questions.collect {|question| {
        "type":"questions",
        "id":question.id,
        "attributes":{
              "title":question.title,
              "description": question.description.truncate(120, separator: ' '),
              "status":question.status
        },
        "meta":{"cantidad de respuestas": question.answers_count}
    } })
    render json:  JSON.pretty_generate({"data": questions_json}),status: 200
  end

  def question_answers_api_json(question, answers)

    response_json = question_api_json(question)
    response_json.merge!("included":  answers.collect {|answer| {
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
              }
        }
      }
    } )
    render json:  JSON.pretty_generate(response_json),status: 200
  end

  def create
    if(request.request_parameters[:title].nil? | request.request_parameters[:description].nil?)
      render json: JSON.pretty_generate({"errors": ["error":"Faltan parametros, no se pudo crear"]}), status: 422
    else
      user = find_user_by_token
      question = Question.create_question(request.request_parameters[:title], request.request_parameters[:description], user.id)
      if question.valid?
        render status: 201
      else
        render json: JSON.pretty_generate({"errors": [question.errors.as_json]}), status: 422
      end
    end
  end

  def show
    if question = Question.exists(params[:id])
      if params[:included].nil?
        render json: JSON.pretty_generate(question_api_json(question)), status: 200
      else
        answers = Answer.all_answers_for_question(params[:id])
        question_answers_api_json(question, answers)
      end
    else
      render json: JSON.pretty_generate({"errors": ["error": "parametro invalido"]}), status: 422
    end
  end

  def index
    if params[:sort].nil?
      questions = Question.fifty_latest
      questions_api_json(questions)
    elsif params[:sort].eql? "latest"
      questions = Question.fifty_latest
      questions_api_json(questions)
    elsif params[:sort].eql? "pending_first"
       questions = Question.fifty_pending
       questions_api_json(questions)
    elsif params[:sort].eql? "needing_help"
      questions = Question.fifty_needing_help
      questions_api_json(questions)
    else
      render json: JSON.pretty_generate({"errors": ["error": "parametro invalido"]}), status: 422
    end
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
          render json: JSON.pretty_generate({"errors": ["error": "debe enviar title y/o description a modificar"]}), status: 422
      end
    else
      render json: JSON.pretty_generate({"errors": ["error": "no tiene permiso para modificar la pregunta"]}), status: 401
    end
  end

  def resolve
    user = find_user_by_token
    if Question.is_answered(params[:id])
      render json: JSON.pretty_generate({"errors": ["error": "la pregunta ya tiene una respuesta correcta"]}), status: 422
    elsif question = Question.check_user_has_question(user, params[:id])
      if (Answer.is_answer_of(params[:answer_id],params[:id]))
        Answer.mark_as_correct(params[:answer_id])
        Question.mark_as_resolved(params[:id])
        render status: 200
      else
        render json: JSON.pretty_generate({"errors": ["error": "la pregunta y la respuesta indicadas en los parametros no se corresponden"]}), status: 422
      end
    else
      render json: JSON.pretty_generate({"errors": ["error": "no tiene permiso para modificar la pregunta como respondida"]}), status: 401
    end
  end

  def destroy
    if Question.exists(params[:id])
      user = find_user_by_token
      if Answer.question_has_answers(params[:id])
        render json: JSON.pretty_generate({"errors": ["error": "la pregunta no se puede borrar porque tiene respuestas"]}), status: 422
      elsif Question.check_user_has_question(user, params[:id])
        Question.delete_question(params[:id])
        render status: 200
      else
        render json: JSON.pretty_generate({"errors": ["error": "no tiene permiso para borrar la pregunta"]}), status: 401
      end
    else
        render json: JSON.pretty_generate({"errors": ["error": "no existe una pregunta con el id enviado"]}), status: 422
    end
  end

  private :check_token, :find_user_by_token, :questions_api_json, :question_api_json, :question_answers_api_json

end
