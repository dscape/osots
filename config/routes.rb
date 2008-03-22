ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'questions'

  map.resources :questions, :exams
  map.resources :users, 
                :member => { :change_password => :any, :change_roles => :any, :suspend => :put, :unsuspend => :put, :purge => :delete },
                :collection => { :recover_password => :any }
  map.resource :session

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil, 
                                             :conditions => { :method => :get }
  map.sign_up '/signup', :controller => 'users', :action => 'new', :conditions => { :method => :get }
  map.sign_in '/signin', :controller => 'sessions', :action => 'new', :conditions => { :method => :get }
  map.sign_out '/signout', :controller => 'sessions', :action => 'destroy', :conditions => { :method => :delete }
  map.reset_password '/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password'
  
  map.prepare_exam '/prepare_exam', :controller => 'exams', :action => 'prepare_exam', :conditions => { :method => :get }

  map.current_question '/current_question', :controller => 'answers', :action => 'new', 
               :conditions => { :method => :get }
               
  map.connect '/current_question', :controller => 'answers', :action => 'create', 
               :conditions => { :method => :post }
  map.result '/result/:id', :controller => 'results', :action => 'show_or_create', :conditions => { :method => :get }
end