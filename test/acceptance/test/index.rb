# frozen_string_literal: true

%i[alpha beta gamma].each do |index|
  describe http("http://localhost:9201/#{index}") do
    its('status') { should eq 200 }
  end
end

%i[delta epsilon].each do |index|
  describe http("http://localhost:9201/#{index}") do
    its('status') { should eq 404 }
  end
end
