Rails.application.routes.draw do
  resources :questions, :answers
  resources :sessions, :users, only: [:create] #SOLAMENTE USA ESTA RUTA
end                            #LO MISMO PARA BEFORE ACTION
#TESTEAR SOLAMENTE EL MODELO
