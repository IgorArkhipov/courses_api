# frozen_string_literal: true

Rails.application.routes.draw do
  jsonapi_resources :authors do
    jsonapi_related_resources :authored_courses
  end
  jsonapi_resources :talents do
    jsonapi_related_resources :courses
  end
  jsonapi_resources :courses do
    jsonapi_related_resource :author
    jsonapi_related_resources :talents
  end
end
