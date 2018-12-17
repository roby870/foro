# README



Luego de clonar el repositorio, ejecutar en el directorio raíz del directorio clonado:

bundle install

para instalar todas las dependencias que utiliza el proyecto. Luego, siempre en el directorio clonado, ejecutar:

rails db:migrate

para generar la base de datos. Se puede inicializar la base con un set de datos de prueba, para cargar los datos ejecutar:

rails db:seed 

La api corre localmente ejecutando en el directorio del proyecto:

bundle exec rails s

Puma escucha las peticiones en tcp://0.0.0.0:3000

Para correr todos los tests, ejecutar en el directorio del proyecto:

rails test

