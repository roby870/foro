require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "se crea una pregunta si tiene seteados los siguientes atributos: title, description, user_id" do
      assert questions(:pregunta).valid?
  end

  test "no se crea una pregunta si no tiene seteado el atributo description" do
    pregunta = Question.new(title: "sumar", user_id: 1)
    assert_not pregunta.valid?
  end

  test "no se crea una pregunta si no tiene seteado el atributo title" do
    pregunta = Question.new(description: "suma de dos flotantes", user_id: 1)
    assert_not pregunta.valid?
  end

  test "no se crea una pregunta si no tiene seteado el usuario que hizo la pregunta" do
    pregunta = Question.new(title: "sumar", description: "suma de dos flotantes")
    assert_not pregunta.valid?
  end

  test "las preguntas se asignan correctamente al usuario que las crea" do
    assert Question.check_user_has_question(users(:juan), questions(:pregunta).id)
    assert_not Question.check_user_has_question(users(:pepe), questions(:pregunta).id)
  end

  test "actualizar titulo" do
    Question.update_title('Como saber la longitud de un string?', questions(:pregunta))
    assert_equal questions(:pregunta).title, 'Como saber la longitud de un string?'
  end

  test "actualizar descripcion" do
    Question.update_description('quiero contar cuantos caracteres tiene un string pero sin contar los espacios en blanco', questions(:pregunta))
    assert_equal questions(:pregunta).description, 'quiero contar cuantos caracteres tiene un string pero sin contar los espacios en blanco'
  end

  test "marcar una pregunta como respondida" do
    Question.mark_as_resolved questions(:pregunta).id, answers(:respuesta).id
    assert Question.find_by(id: questions(:pregunta).id, status: true)
  end

  test "borrar una pregunta" do
    Question.delete_question(questions(:pregunta).id)
    assert_not Question.find_by(id: questions(:pregunta).id)
  end


end
