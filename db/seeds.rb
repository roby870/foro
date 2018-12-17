# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |i|
  User.create_user("User_#{i}","#{i}","screen_#{i}","#{i}@gmail.com")
end

Question.create(title: "no puedo acceder a las variables de sesion", description: "la variable sesion tiene el valor nil cada vez que accedo", user_id: 1)
Question.create(title: "tengo errores con las operaciones de floats", description: "en cualquier operacion se levanta una excepcion", user_id: 2)
Question.create(title: "realizar migraciones", description: "no puedo correr las migraciones, el comando migrate me tira todo tipo de error :(", user_id: 3)
Question.create(title: "truncar un string", description: "estoy usando rails y quiero truncar un string de una manera simple, lo estoy haciendo iterando sobre el string pero no me sale", user_id: 4)
Question.create(title: "como ejecutar comandos en bash?", description: "no me sale", user_id: 4)

Answer.create(content: "tenes que detener la app y volver a iniciarla", question_id: 1, user_id: 2)
Answer.create(content: "tenes que acceder a la variable SESSION", question_id: 1, user_id: 3)
Answer.create(content: "en PHP las variables de sesion se encuentran en $_SESSION['variable x']", question_id: 1, user_id: 4)
Answer.create(content: "tenes que transformar cada numero que uses mediante to_f", question_id: 2, user_id:1)
Answer.create(content: "estas usando comas, para los floats tenes que usar un punto", question_id: 2, user_id:4)
Answer.create(content: "no podes usar floats en ese lenguaje", question_id: 2, user_id: 5)
Answer.create(content: "tenes que usar db:migrate", question_id: 3, user_id: 1)
Answer.create(content: "tenes que usar rails db:migrate", question_id: 3, user_id: 4)
Answer.create(content: "tenes que usar truncate", question_id: 4, user_id: 5)
