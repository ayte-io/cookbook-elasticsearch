# frozen_string_literal: true

describe http('http://localhost:9201/alpha/doc/1') do
  its('status') { should eq 200 }
  its('body') { should match JSON.dump(id: 1) }
end

describe http('http://localhost:9201/alpha/doc/2') do
  its('status') { should eq 404 }
end
