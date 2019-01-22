# frozen_string_literal: true

(1..2).each do |als|
  describe http("localhost:9201/_alias/#{als}") do
    its('status') { should eq 200 }
    its('body') { should include 'alpha' }
  end

  describe http("localhost:9201/_alias/#{als}") do
    its('status') { should eq 200 }
    its('body') { should_not match 'beta' }
  end
end

describe http('localhost:9201/_alias/3') do
  its('status') { should eq 404 }
end
