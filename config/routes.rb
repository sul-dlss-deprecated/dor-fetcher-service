# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # APO Routes
  resources :apos, :tags, :collections, defaults: { format: 'json' }

  root 'ok_computer/ok_computer#show', check: 'default'
end
