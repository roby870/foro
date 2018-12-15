require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "se crea un usuario si tiene seteados los siguientes atributos: username, password_hash, email, screen_name" do
      assert users(:juan).valid?
  end

  test "no se crea un usuario si ya se encuentra registrado en la base de datos su username" do
    user = User.new(username: 'juan5', screen_name: 'pedro', password_hash: 'asjd3248djdsd', email: 'pedro@gmail.com')
    assert_not user.valid?
  end

  test "no se crea un usuario si ya se encuentra registrado en la base de datos su email" do
    user = User.new(username: 'pedro', screen_name: 'pedro', password_hash: 'asjd3248djdsd', email: 'juan@hotmail.com')
    assert_not user.valid?
  end

  test "no se crea un usuario si no tiene el atributo screen_name seteado" do
     user = User.new(username: 'pedro', password_hash: 'asjd3248djdsd', email: 'pedro@gmail.com')
     assert_not user.valid?
  end

  test "no se crea un usuario si no tiene el atributo username seteado" do
     user = User.new(screen_name: 'pedro', password_hash: 'asjd3248djdsd', email: 'pedro@gmail.com')
     assert_not user.valid?
  end

  test "no se crea un usuario si no tiene el atributo email seteado" do
     user = User.new(screen_name: 'pedro', password_hash: 'asjd3248djdsd', username: 'pedro')
     assert_not user.valid?
  end

  test "no se crea un usuario si no tiene el atributo password_hash seteado" do
     user = User.new(screen_name: 'pedro', email: 'pedro@gmail.com', username: 'pedro')
     assert_not user.valid?
  end

  test "la clave se guarda hasheada pero se recupera tal como fue ingresada por el usuario" do
    User.create_user('ana', '1234', 'ana', 'ana@gmail.com')
    assert_equal User.find_by(username: 'ana').password, '1234'
  end

  test "autenticar" do
    User.create_user('ana', '1234', 'ana', 'ana@gmail.com')
    assert User.authenticate('ana', '1234')
  end

  test "autorizacion mediante token" do
    User.save_token(users(:juan), 'adas723rydsds232')
    assert User.check_token('adas723rydsds232')
  end

  test "no se autoriza mediante token invalido" do
    User.save_token(users(:juan), 'adas723rydsds232')
    assert_not User.check_token('1234')
  end



  end
