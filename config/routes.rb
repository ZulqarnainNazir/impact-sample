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
    get :authenticate_facebook_page, to: 'authentications#facebook_page'

    devise_for :users, controllers: {
      confirmations: 'users/confirmations',
      passwords: 'users/passwords',
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      unlocks: 'users/unlocks',
    }

    devise_scope :user do
      authenticated :user do
        root to: 'businesses#index', as: :authenticated_root
      end
      unauthenticated :user do
        root to: 'users/sessions#new'
      end
      patch '/users/confirmation' => 'users/confirmations#update'
    end

    namespace :connect do
      get :locable, to: 'session_redirects#locable'
      get :receive_locable, to: 'session_creates#locable'
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
        resource :dashboard_tour_viewed, only: %i[create]

        namespace :content do
          root to: 'roots#show'
          resource :images_upload, only: %i[new create]
          resource :feed, only: %i[show]
          resources :before_afters, only: %i[new create edit update destroy]
          resources :event_definitions, only: %i[new create edit update destroy], path: 'events' do
            get :clone, on: :member
          end
          resources :event_imports, only: %i[index] do
            post :import_all, on: :collection
            post :import, on: :member
          end
          resources :galleries, only: %i[new create edit update destroy]
          resources :images, only: %i[index edit update destroy]
          resources :pdfs
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
          resource :feedbacks_automation, only: %i[update]
          resource :review_notifications, only: %i[edit update]
          resource :reviews_automation, only: %i[update]
          resources :contact_messages, only: %i[index show destroy]
          resources :customers, only: %i[index new create edit update destroy] do
            resources :feedbacks, only: %i[new create]
            resources :customer_notes, only: %i[new create edit update destroy]
          end
          resources :feedbacks, only: %i[index show destroy] do
            resource :review_invitation, only: %i[create]
          end
          resources :reviews, only: %i[index show destroy] do
            resource :review_publication, only: %i[create destroy]
          end
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
            get :table, on: :collection
            resource :publications, only: %i[create destroy]
          end
        end

        namespace :accounts do
          root to: 'roots#show'
          resource :locable, only: %i[edit update destroy]
          resource :facebook, only: %i[edit update destroy]
        end

        resource :marketing, only: %i[show]
        resource :super_settings, only: %i[edit update]
        resources :alliances, only: %i[index]
        resources :authorizations, only: %i[index new create destroy]
        resources :images, only: %i[index]
        resources :content_categories, only: %i[new create]
        resources :content_tags, only: %i[index create]
      end
    end

    resources :locations, only: %i[index new create]
  end

  scope module: :website, as: :website, constraints: WebsiteConstraint.new do
    root to: 'home_pages#show'

    resource :about_page, path: 'about', only: %i[show]
    resource :blog_page, path: 'blog', only: %i[index show]
    resource :contact_page, path: 'contact', only: %i[show create]
    resource :feedback, only: %i[new create show], path: 'feedback'
    resource :share, only: %i[show]

    resources :before_afters, only: %i[show]
    resources :content_categories, only: %i[show], path: 'categories'
    resources :content_tags, only: %i[show], path: 'tags'
    resources :events, only: %i[index show]
    resources :galleries, only: %i[index show] do
      resources :gallery_images, only: %i[show]
    end
    resources :offers, only: %i[show]
    resources :posts, only: %i[show]
    resources :quick_posts, only: %i[show]
    resources :reviews, only: %i[index show new create]

    get '/:year/:month/:day/:id/:slug', to: 'generic_posts#show', as: :generic_post, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/
    get '/:year/:month/:day/:id/:gallery_slug/:image_id/:image_slug', to: 'generic_posts#show', as: :gallery_image, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/
    get '/:year/:month/:day/:id/:gallery_slug/:image_id', to: 'generic_posts#show', as: :gallery_image_no_title, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/

    get '*id', to: 'custom_pages#show', as: :custom_page
  end
end
