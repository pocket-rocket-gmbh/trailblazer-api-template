require "rails_helper"

RSpec.describe "Me Endpoint - v1/users/me", type: :request do
  before(:all) do
    @endpoint = '/v1/users/me'
    @organization = setup_organization

    # setup employee
    @user = FactoryBot.create(:user, organization: @organization)

    # Login users to get tokens
    @user_token = login(@user.email, @user.password)

    get_json @endpoint, {}, @user_token
  end

  it 'should return status 200' do
    expect(response.status).to eq 200
  end

  it 'should retrieve the logged in users information' do
    body = response.parsed_body
    res = body['resource']

    expect(res['id']).to eq @user.id
    expect(res['firstname']).to eq @user.firstname
    expect(res['lastname']).to eq @user.lastname
    expect(res['email']).to eq @user.email
    expect(res['organization']['name']).to eq @user.organization.name
    expect(res['created_at']).not_to be_nil
    expect(res['updated_at']).not_to be_nil
  end
end
