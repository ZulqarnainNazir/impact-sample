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

    devise_for :users, controllers: {
      confirmations: 'users/confirmations',
      passwords: 'users/passwords',
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      unlocks: 'users/unlocks',
    }

    namespace :connect do
      get :cce, to: 'cces#redirect', as: :cce
      get :session_create, to: 'sessions#create'
    end

    namespace :onboard do
      namespace :website do
        resources :businesses, only: %i[new create edit update destroy] do
          post :import_cce, on: :collection
          post :import_facebook, on: :collection
          resource :location, only: %i[edit update]
          resource :lines, only: %i[edit update]
          resource :delivery, only: %i[edit update]
          resource :customers, only: %i[edit update]
          resource :values, only: %i[edit update]
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
          resource :images_upload, only: %i[new create]
          resource :feed, only: %i[show]
          resources :before_afters, only: %i[new create edit update destroy]
          resources :event_definitions, only: %i[new create edit update destroy], path: 'events' do
            get :clone, on: :member
          end
          resources :galleries, only: %i[new create edit update destroy]
          resources :images, only: %i[index edit update destroy]
          resources :offers, only: %i[new create edit update destroy] do
            get :clone, on: :member
          end
          resources :posts, only: %i[new create edit update destroy]
          resources :quick_posts, only: %i[new create edit update destroy]
        end

        namespace :data do
          root to: 'roots#show'
          resource :customers, only: %i[edit update]
          resource :delivery, only: %i[edit update]
          resource :details, only: %i[edit update]
          resource :lines, only: %i[edit update]
          resource :location, only: %i[edit update]
          resource :openings, only: %i[edit update]
          resource :social_profiles, only: %i[edit update]
          resource :team_members_positions, only: %i[edit update]
          resource :values, only: %i[edit update]
          resources :team_members, only: %i[index new create edit update destroy]
        end

        namespace :crm do
          root to: 'roots#show'
          resource :contact_message_notifications, only: %i[edit update]
          resources :contact_messages, only: %i[index show]
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
          resource :sidebars, only: %i[edit update]
          resource :theme, only: %i[edit update]
          resources :custom_pages, only: %i[new create edit update]
          resources :redirects, only: %i[index new create edit update destroy]
          resources :webpages, only: %i[index destroy] do
            resource :publications, only: %i[create destroy]
          end
        end

        resource :marketing, only: %i[show]
        resource :super_settings, only: %i[edit update]
        resources :alliances, only: %i[index]
        resources :authorizations, only: %i[index new create destroy]
        resources :images, only: %i[index]
        resources :reviews, only: %i[index]
      end
    end

    resources :locations, only: %i[index new create]
  end

  scope module: :website, as: :website, constraints: WebsiteConstraint.new do
    root to: 'home_pages#show'

    resource :about_page, path: 'about', only: %i[show]
    resource :blog_page, path: 'blog', only: %i[show]
    resource :contact_page, path: 'contact', only: %i[show create]

    resources :before_afters, only: %i[show]
    resources :events, only: %i[index show]
    resources :galleries, only: %i[index show] do
      resources :gallery_images, only: %i[show]
    end
    resources :offers, only: %i[show]
    resources :posts, only: %i[show]
    resources :quick_posts, only: %i[show]

    get '*id', to: 'custom_pages#show', as: :custom_page
  end
end
