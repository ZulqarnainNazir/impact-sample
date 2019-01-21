class PlatformConstraint
  def matches?(request)
    host_match = request.host.match(Regexp.escape(Rails.application.secrets.host))
    blank_or_impact_subdomain = (request.subdomain.blank? || request.subdomains.first == 'impact' || request.subdomains.first == 'www') && request.subdomains.first != 'listings'

    host_match && blank_or_impact_subdomain
  end
end

class WebsiteConstraint
  def matches?(request)
    host_match = request.host.match(Regexp.escape(Rails.application.secrets.host))
    present_and_not_impact_subdomain = request.subdomain.present? && request.subdomains.first != 'impact' && request.subdomains.first != 'listings' && request.subdomains.first != 'www'

    !host_match || present_and_not_impact_subdomain
  end
end

class ListingConstraint
  def matches?(request)
    host_match = request.host.match(Regexp.escape("listings.locabledev.com"))
    listings_subdomain = request.subdomain.present? && request.subdomains.first == 'listings' && request.subdomains.first != 'www' && request.subdomains.first != 'impact'

    host_match || listings_subdomain
  end
end

Rails.application.routes.draw do



  scope module: :listing, as: :listing, constraints: ListingConstraint.new do
    root to: 'listings#index'
    match '/:lookup', to: 'listings#overview', via: :get
    match '/:lookup/directories', to: 'directories#index', :as => 'directories', via: :get
    match '/:lookup/directories/:id', to: 'directories#show', :as => 'directory', via: :get
    match '/:lookup/calendars', to: 'calendars#index', :as => 'calendars', via: :get
    match '/:lookup/calendars/:id', to: 'calendars#show', :as => 'calendar', via: :get
    match '/:lookup/content', to: 'content#index', :as => 'contents', via: :get
    match '/:lookup/before_after/:content_type/', to: 'content#before_after', :as => 'before_after', via: :get
    match '/:lookup/offer/:content_type/', to: 'content#offer', :as => 'offer', via: :get
    match '/:lookup/post/:content_type/', to: 'content#post', :as => 'post', via: :get
    match '/:lookup/job/:content_type/', to: 'content#job', :as => 'job', via: :get
    match '/:lookup/quick_post/:content_type/', to: 'content#quick_post', :as => 'quick_post', via: :get
    match '/:lookup/event/:content_type/', to: 'content#event', :as => 'event', via: :get

    match '/:lookup/reviews/create', to: 'reviews#create', :as => 'create_review', via: :post
    match '/:lookup/reviews/new', to: 'reviews#new', :as => 'new_review', via: :get
    match '/:lookup/reviews', to: 'reviews#index', :as => 'reviews', via: :get
    match '/:lookup/reviews/:id', to: 'reviews#show', :as => 'review', via: :get

    match '/:lookup/:content_type/', to: 'content#content_type', :as => "content_type", via: :get
    match '/:lookup/:content_type/gallery/:gallery_image', to: 'listings#gallery_image', :as => "gallery_image", via: :get

    match '/:lookup/reviews/all', to: 'reviews#index', via: :get
    match '/:lookup/shares/share', to: 'shares#show', :as => 'share', via: :get


    # resources :galleries, only: %i[index show] do
    #   resources :gallery_images, only: %i[show]
    # end
  end

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

    namespace :super do
      resources :communities
      resources :to_do_lists
      resources :event_feeds, except: [:show]
      resources :missions do
        get :custom, on: :collection
      end
      resources :billing_dashboard, only: [:none] do
        collection do

        end
      end
      resources :users, only: [:none] do
        collection do
          get :all_users
          get :super_admins
        end
      end
      resources :email_data, only: [:index] do
        collection do
          get :overview
        end
      end
      resources :business_data, only: [:index, :edit, :update] do
        member do
          get :merge_with
          get :select_merge_fields
          put :merge_now
          # put :update_community
        end
      end

      resources :subscription_plans
      resources :affiliates, only: [:index]
      resources :to_dos, only: :index
      resources :to_do_notification_settings, only: %i[index create]
      resources :subscriptions_data, only: [:none] do
        collection do
          get :subscription_stats
          get :subscriptions
          get :inactive_subscriptions
          get :all_subscriptions
          get :past_dues
        end
      end
    end

    resources :sns, only: [:none] do
      collection do
        post :bounce_data
        post :report_data
      end
    end

    namespace :widgets do
      get '/review_widgets/:uuid', to: 'review_widgets#index'
      get '/directory_widgets/:uuid', to: 'directory_widgets#index'
      get '/directory_widgets/:uuid/:business_id', to: 'directory_widgets#show', as: :directory_widget
      get '/content_feed_widgets/:uuid', to: 'content_feed_widgets#index'
      get '/content_feed_widgets/:uuid/:content_id', to: 'content_feed_widgets#show'
      get '/calendar_widgets/:uuid', to: 'calendar_widgets#index'
      get '/calendar_widgets/:uuid/:content_id', to: 'calendar_widgets#show'
      get '/contact_form_widgets/:uuid', to: 'contact_form_widgets#index'
      post '/contact_form_widgets/:uuid', to: 'contact_form_widgets#submit', as: :contact_form_submit
    end

    namespace :onboard do
      resources :users, only: %i[new create]
      resources :businesses, only: %i[create edit update], format: :json
      get '/businesses/:id/details', to: 'business_details#edit', as: :business_details
      patch '/businesses/:id/details', to: 'business_details#update', as: :business_details_update
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
        resources :account_modules do
          get 'remote_create', :on => :collection
        end

          resources :subscriptions, except: [:index] do
            resources :affiliate_payments, only: %i[show edit update] do
              get 'unpaid_affiliate_commissions', :on => :collection
              post 'mark_as_paid', :on => :collection
            end
            resources :affiliate_sales, only: %i[show index delete] do
              collection do
                get 'referred_businesses'
                get 'commissions'
              end
            end
            resources :subscription_payments, only: %i[show]
            collection do
              get :dashboard, :thanks, :plans, :canceled, :return_to_impact, :initial_plan_setup
              match 'billing' => "subscriptions#billing", via: [ :get, :post ]
              match 'setup_billing' => 'subscriptions#initial_billing_setup', via: [ :get, :post ]
              #^setup_billing is the initial billing page a user would encounter when they sign-up;
              #afterwards, subscriptions#billing is used. #enter_billing_information is sleeker
              #than #billing and presents a better image to first-time customers.
              match 'plan' => "subscriptions#plan", via: [ :get, :post ]
              get 'billing_history'
              get 'subscription_dashboard'
            end
          end

        namespace :content do
          root to: 'feeds#show'
          get '/activate', to: 'base#index'
          resource :images_upload, only: %i[new create]
          resource :feed, only: %i[show]
          resources :before_afters, only: %i[new create edit update destroy] do
            resources :shares, only: %i[new create]
            get :sharing_insights
          end
          resources :event_definitions, only: %i[new create edit update destroy], path: 'events' do
            resources :shares, only: %i[new create]
            get :sharing_insights
            get :clone, on: :member
          end
          resources :event_feeds, except: [:index] do
            post :reprocess, on: :member
            resources :imported_event_definitions, except: [:show, :index, :new, :create]
          end
          resource :event_import_notifications, only: %i[edit update]
          resources :event_imports, only: :index do
            post :import_all, on: :collection
            post :import, on: :member
          end
          # TODO Add jobs here
          resources :jobs, only: %i[new create edit update destroy] do
            resources :shares, only: %i[new create]
            get :sharing_insights
            get :clone, on: :member
          end
          resources :galleries, only: %i[new create edit update destroy] do
            resources :shares, only: %i[new create]
            get :sharing_insights
          end
          resources :images, only: %i[index edit update destroy]
          resources :pdfs
          resources :category_tag_management, only: [:index] do
            collection do
              post :create_content_category
              post :create_content_tag
              get :new_content_category
              delete :delete_content_category
              delete :delete_content_tag
            end
          end
          resources :offers, only: %i[new create edit update destroy] do
            resources :shares, only: %i[new create]
            get :sharing_insights
            get :clone, on: :member
          end
          resources :posts, only: %i[new create edit update destroy] do
            resources :shares, only: %i[new create]
            get :clone, on: :member
            get :sharing_insights
          end
          resources :quick_posts, only: %i[new create edit update destroy] do
            resources :shares, only: %i[new create]
            get :sharing_insights
            get :clone, on: :member
          end
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
          resources :contacts, only: %i[index new create edit update destroy] do
            resources :feedbacks, only: %i[new create]
            resources :crm_notes, only: %i[new create edit update destroy]
          end
          resources :imports, only: %i[index update] do
            collection do
              get 'download_contact_template'
              get 'download_company_template'
              get '/import_status_check/:job_id', action: :import_status_check, as: :import_status_check
              post 'review'
              post 'review_duplicates'
              post 'process_csv'
              post 'match_columns'
            end
          end
          resources :company_lists, only: %i[index new create edit update destroy]
          get 'company_lists/following', to: 'following#index'
          resources :follower_notifications, only: [] do
            collection do
              get :edit
              patch :update
            end
          end
          resources :contact_forms, only: %i[index new create edit update destroy]
          resources :form_submissions, only: %i[index show destroy]
          resources :companies, only: %i[index new create edit update destroy] do
            resources :business, only: %i[new create edit update]
            resources :crm_notes, only: %i[new create edit update destroy]
          end
          resources :feedbacks, only: %i[index new create show destroy] do
            resource :review_invitation, only: %i[create]
          end
          resources :reviews, only: %i[index show destroy] do
            resource :review_publication, only: %i[create destroy]
          end
          resources :invites, only: %i[index new create]
        end

        namespace :tools do
          root to: 'roots#index'
          resources :review_widgets, only: %i[index new create edit update destroy]
          resources :directory_widgets, only: %i[index new create edit update destroy]
          resources :content_feed_widgets, only: %i[index new create edit update destroy]
          resources :calendar_widgets, only: %i[index new create edit update destroy]
        end

        namespace :website do
          root to: 'roots#show'
          resource :about_page, only: %i[edit update]
          resource :add_website, only: [:none] do
            collection do
              get :new_website
              match 'upgrade_to_new_plan', via: [:get, :post]
            end
          end
          resource :blog_page, only: %i[edit update]
          resource :contact_page, only: %i[edit update]
          resource :details, only: %i[edit update]
          resource :home_page, only: %i[edit update]
          resource :menus, only: %i[edit update]
          resource :meta, only: %i[edit update]
          resource :sidebars, only: %i[edit update]
          resource :theme, only: %i[edit update] do
            get :manage_fonts
          end
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
        resources :marketing_assistant, only: :index
        resource :super_settings, only: %i[edit update] do
          post 'create_affiliation', on: :member
          delete 'delete_affiliation', on: :member
          post 'add_legacy_plan', on: :member
          delete 'delete_legacy_plan', on: :member
          post 'associate_with_affiliate', on: :member
        end
        resources :alliances, only: %i[index]
        resources :authorizations, only: %i[index new create destroy update]
        resources :images, only: %i[index]
        resources :content_categories, only: %i[new create]
        resources :content_tags, only: %i[index create]
        resources :reminders, only: :index
        resources :activity_calendar, only: :index do
          get :timeline, on: :collection
        end
        resources :mission_instance_comments, only: :create
        resources :mission_notes, only: :update
        resources :mission_notifications, only: [] do
          collection do
            get :edit
            put :update
          end
        end
        resources :to_do_lists do
          post :add_mission, on: :member
          post :remove_mission, on: :member
        end
        resources :missions, only: %i[index show] do
          get :custom, on: :collection
          resources :mission_assignments, only: :create
        end
        resources :mission_histories, only: :index
        resources :mission_instances, only: %i[edit update create new] do
          collection do
            post :complete
            post :skip
            post :snooze
            post :deactivate
            post :activate
            post :update_list
          end
        end
        resources :to_dos, only: %i[index show create update destroy] do
          resources :comments, only: :create

          member do
            put :submit_for_review
            put :mark_as_complete
            put :remove
            put :reactivate
          end

          collection do
            resources :notification_settings, only: %i[index update]
          end
        end
      end
    end

    resources :locations, only: %i[index new create]
  end

  namespace :async do
    get 'calendar', to: 'widgets#calendar'
    get 'quick_post', to: 'widgets#quick_post'
  end

  scope module: :website, as: :website, constraints: WebsiteConstraint.new do
    root to: 'home_pages#show'
    get '/robots.:format' => 'robots#robots'
    resource :about_page, path: 'about', only: %i[show]
    resource :blog_page, path: 'blog', only: %i[index show]
    resource :contact_page, path: 'contact', only: %i[show create]
    resource :feedback, only: %i[new create show], path: 'feedback'
    resource :share, only: %i[show]

    resources :before_afters, only: %i[show]
    resources :content_categories, only: %i[show], path: 'categories'
    resources :content_tags, only: %i[show], path: 'tags'
    resources :events, only: %i[index show]
    resources :jobs, only: %i[index show]
    resources :galleries, only: %i[index show] do
      resources :gallery_images, only: %i[show]
    end
    resources :offers, only: %i[show]
    resources :posts, only: %i[show]
    resources :quick_posts, only: %i[show]
    resources :reviews, only: %i[index show new create]

    get '/:type/preview/:id', to: 'generic_posts#preview', as: :generic_post_preview
    get '/:galleries/:gallery_id/:type/preview/:id', to: 'generic_posts#preview'
    # ^ preview route for gallery images
    get '/:year/:month/:day/:id/:slug(/:uuid)', to: 'generic_posts#show', as: :generic_post, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/
    get '/:year/:month/:day/:id/:gallery_slug(/:uuid)/:image_id/:image_slug', to: 'generic_posts#show', as: :gallery_image, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/
    get '/:year/:month/:day/:id/:gallery_slug(/:uuid)/:image_id', to: 'generic_posts#show', as: :gallery_image_no_title, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/

    get '*id', to: 'custom_pages#show', as: :custom_page
  end
end
