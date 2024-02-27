Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/platform/auth', to: 'api/v1/authentication#authenticate'
  post '/MMGG/Ipn', to: 'api/v1/payments#payment_ipn'

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      post '/ussd/payment', to: 'payments#init_payment'
      post '/admin/contravention/save', to: 'contraventions#save_record'
      post '/admin/contravention/update', to: 'contraventions#update_record'
      get '/admin/contravention/retrieve', to: 'contraventions#fetch_record'
      get '/admin/transactions/retrieve', to: 'contraventions#fetch_transaction'
      get '/admin/contravention/list/:model_code', to: 'contraventions#fetch_records'
      post '/admin/contravention/delete', to: 'contraventions#destroy_record' # Route Defined and used by BO to request and delete data

      match '/data', to: 'main#data', via: [:get, :post]
      get 'stats/:model_name', to: 'main#stats'
      post 'transactions/filter', to: 'main#transactions_filter'
      post 'contravention/types', to: 'main#fetch_contravention_types'
      post 'contravention/type', to: 'main#fetch_contravention_type'
      post 'transactions', to: 'main#transactions'
      match '/dataset/export', to: 'main#export_data', via: [:get, :post]

      post 'contravention/controls/inputs', to: 'main#verify_inputs_ussd'
    end
  
  end
end
