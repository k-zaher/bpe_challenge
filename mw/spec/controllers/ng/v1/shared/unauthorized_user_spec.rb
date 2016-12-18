require "set"

shared_examples_for "Unauthorized User" do
  before :each do
    request.headers['Authorization'] = "Basic #{user_auth_data}"
  end

  it 'return 403' do
    expect(response).to have_http_status(403)
  end
end