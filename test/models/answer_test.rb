require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

   test "se crea una respuesta si tiene seteados los siguientes atributos: content, question_id, user_id" do
     assert answers(:respuesta).valid?
   end

   test "no se crea una respuesta si no tiene seteado el atributo content" do
     answer = Answer.new(question_id: 1, user_id: 1)
     assert_not answer.valid?
   end

   test "no se crea una respuesta si no tiene seteado el atributo question_id" do
     answer = Answer.new(content: 'tenes que usar el metodo to_s, es de la libreria standard de Ruby', user_id: 1)
     assert_not answer.valid?
   end

   test "no se crea una respuesta si no tiene seteado el atributo user_id" do
     answer = Answer.new(question_id: 1, content: 'tenes que usar el metodo to_s, es de la libreria standard de Ruby')
     assert_not answer.valid?
   end

   test "no se crea una respuesta si el usuario asignado a esa respuesta no existe" do
     answer = Answer.new(question_id: 1, content: 'tenes que usar el metodo to_s, es de la libreria standard de Ruby', user_id: 9)
     assert_not answer.valid?
   end

   test "no se crea una respuesta a una pregunta que no existe" do
     answer = Answer.new(question_id: 9, content: 'tenes que usar el metodo to_s, es de la libreria standard de Ruby', user_id: 1)
     assert_not answer.valid?
   end

   test "se asocia correctamente una cierta respuesta a una cierta pregunta" do
     assert Answer.is_answer_of(answers(:respuesta).id, questions(:pregunta).id)
     assert_not Answer.is_answer_of(answers(:respuesta).id, questions(:otraPregunta).id)
   end

   test "marcar una respuesta como correcta" do
     Answer.mark_as_correct answers(:respuesta).id
     assert Answer.find_by(id: answers(:respuesta).id, checked: true)
   end

   test "borrado de una respuesta" do
     Answer.delete_answer_to_question(answers(:respuesta).id, questions(:pregunta).id)
     assert_not Answer.find_by(id: answers(:respuesta).id)
   end

   test "no borra una respuesta si no se corresponde con la pregunta" do
     Answer.delete_answer_to_question(answers(:respuesta).id, questions(:otraPregunta).id)
     assert Answer.find_by(id: answers(:respuesta).id)
   end

   test "chequeo de la existencia de respuestas asociadas a preguntas" do
     assert Answer.question_has_answers(questions(:pregunta).id)
     assert_not Answer.question_has_answers(questions(:otraPregunta).id)
   end

end
