elasticsearch_request 'default' do
  port 9201
  user :user
  password :password
  retries 15
  retry_delay 1
end
