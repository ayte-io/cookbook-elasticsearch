# frozen_string_literal: true

(3..7).each do |id|
  describe http("http://localhost:9201/alpha/doc/#{id}") do
    its('status') { should eq 200 }
    its('body') { should match(/{"id":\s*#{id}/) }
  end
end
