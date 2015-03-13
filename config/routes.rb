class PlatformConstraint
  def matches?(request)
    request.subdomains.first == 'www' || request.subdomain.blank?
  end
end

class WebsiteConstraint
  def matches?(request)
    request.subdomains.first != 'www' && request.subdomains.first.to_s.match(/[\w\-]+/)
  end
end

Rails.application.routes.draw do
  scope constraints: PlatformConstraint.new do
    root to: 'landings#show'

    as :user do
      patch '/users/confirmation', to: 'devise/custom_confirmations#update', as: :update_user_confirmation
    end

    devise_for :users, controllers: { confirmations: 'devise/custom_confirmations' }

    namespace :alliance_onboard do
      # TODO
    end

    namespace :website_onboard do
      resources :businesses, only: %i[new create edit update destroy] do
        resource :location, only: %i[edit update]
        resource :website, only: %i[edit update]
        resource :home_page, only: %i[edit update]
      end
    end

    resources :businesses, only: %i[index show] do
      scope module: :dashboard do
        resource :details, only: %i[edit update]
        resource :location, only: %i[edit update]
        resource :social_profiles, only: %i[edit update]
        resources :authorizations, only: %i[index new create destroy]

        resource :website, only: %i[] do
          scope module: :website do
            resource :about_page, only: %i[edit update destroy]
            resource :contact_page, only: %i[edit update destroy]
            resource :details, only: %i[edit update]
            resource :home_page, only: %i[edit update destroy]
            resource :theme, only: %i[edit update]
            resources :pages, only: %i[index]
          end
        end
      end
    end
  end

  scope module: :website, as: :website, constraints: WebsiteConstraint.new do
    root to: 'home_pages#show'

    resource :about_page, path: 'about', only: %i[show]
    resource :contact_page, path: 'contact', only: %i[show]
  end
end
