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

    namespace :onboard do
      namespace :website do
        resources :businesses, only: %i[new create edit update destroy] do
          post :import, on: :collection
          resource :location, only: %i[edit update]
          resource :website, only: %i[edit update]
          resource :theme, only: %i[edit update]
        end
      end
    end

    resources :businesses, only: %i[index] do
      scope module: :businesses do
        resource :dashboard, path: '', only: %i[show]

        namespace :content do
          root to: 'roots#show'
          resource :feed, only: %i[show]
          resources :posts, only: %i[new create edit update destroy]
          resources :galleries, only: %i[new create edit update destroy]
          resources :projects, only: %i[new create edit update destroy]
          resources :before_afters, only: %i[new create edit update destroy]
          resources :offers, only: %i[new create edit update destroy]
        end

        namespace :data do
          root to: 'roots#show'
          resource :details, only: %i[edit update]
          resource :location, only: %i[edit update]
          resource :openings, only: %i[edit update]
          resource :social_profiles, only: %i[edit update]
          resource :team_members_positions, only: %i[edit update]
          resources :team_members, only: %i[index new create edit update destroy]
        end

        namespace :crm do
          root to: 'roots#show'
          resources :contact_messages, path: 'submitted-forms', only: %i[index show]
        end

        namespace :website do
          root to: 'roots#show'
          resource :about_page, only: %i[edit update]
          resource :blog_page, only: %i[edit update]
          resource :contact_page, only: %i[edit update]
          resource :details, only: %i[edit update]
          resource :home_page, only: %i[edit update]
          resource :menus, only: %i[edit update]
          resource :meta, only: %i[edit update]
          resource :theme, only: %i[edit update]
          resources :custom_pages, only: %i[new create edit update]
          resources :webpages, only: %i[index] do
            resource :publications, only: %i[create destroy]
          end
        end

        resource :marketing, only: %i[show]
        resources :authorizations, path: 'admins', only: %i[index new create destroy]
        resources :images, only: %i[index]
      end
    end
  end

  scope module: :website, as: :website, constraints: WebsiteConstraint.new do
    root to: 'home_pages#show'

    resource :about_page, path: 'about', only: %i[show]
    resource :blog_page, path: 'blog', only: %i[show]
    resource :contact_page, path: 'contact', only: %i[show create]

    resources :before_afters, only: %i[show]
    resources :galleries, only: %i[show] do
      resources :gallery_images, only: %i[show]
    end
    resources :offers, only: %i[show]
    resources :posts, only: %i[show]
    resources :projects, only: %i[show]

    get '*id', to: 'custom_pages#show', as: :custom_page
  end
end
