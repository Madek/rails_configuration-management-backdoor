Rails.application.routes.draw do
  post '/configuration_management_backdoor/invoke',
       controller: 'configuration_management_backdoor', action: 'invoke'
end
