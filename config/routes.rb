class PlatformConstraint
  def matches?(request)
    host_match = request.host.match(Regexp.escape(Rails.application.secrets.host))
    blank_or_www_subdomain = request.subdomain.blank? || request.subdomains.first == 'www'

    host_match && blank_or_www_subdomain
  end
end

class WebsiteConstraint
  def matches?(request)
    host_match = request.host.match(Regexp.escape(Rails.application.secrets.host))
    present_and_not_www_subdomain = request.subdomain.present? && request.subdomains.first != 'www'

    !host_match || present_and_not_www_subdomain
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
        resources :team_members, only: %i[index new create edit update destroy]

        resource :website, only: %i[] do
          scope module: :website do
            resource :about_page, only: %i[edit update destroy]
            resource :contact_page, only: %i[edit update destroy]
            resource :details, only: %i[edit update]
            resource :home_page, only: %i[edit update destroy]
            resource :theme, only: %i[edit update]
            resources :custom_pages, only: %i[new create edit update destroy]
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

    get '*id', to: 'custom_pages#show', as: :custom_page
  end
end
