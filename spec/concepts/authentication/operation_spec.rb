require 'rails_helper'

describe 'Authentication Lifecycle' do
  before(:all) do
    @organization = FactoryBot.create(:organization)
    @user = FactoryBot.create(:user, organization: @organization)
  end

  context 'authenticate with valid username and password' do
    before(:all) do
      @json_params = { email: @user.email, password: @user.password }
      @result = Authentication::Operations::GenerateToken.(params: @json_params)
    end

    it 'should be successful' do
      expect(@result.success?).to be_truthy
    end

    it 'should set the current_user' do
      expect(@result['current_user']).to eq @user
    end

    it 'should set the jwt_token' do
      expect(@result['jwt_token']).to be_kind_of String
    end

    it 'should store the jwt_token for the user in the db' do
      expect(@result['current_user'].jwt_token).not_to be_nil
      expect(@result['current_user'].jwt_token).to eq @result['jwt_token']
      expect(@result['current_user'].persisted?).to be_truthy
    end

    it 'should generate a decryptable jwt_token' do
      decoded_token = JWT.decode(@result['jwt_token'],
        Rails.application.credentials[:secret_key_base], true, { algorithm: 'HS512'})
    end

    it 'should store the user_id, email, organization_id, role and exp within the token' do
      decoded_token = JWT.decode(@result['jwt_token'],
        Rails.application.credentials[:secret_key_base], true, { algorithm: 'HS512'})
      expect(decoded_token.first['user_id']).to eq @user.id
      expect(decoded_token.first['email']).to eq @user.email
      expect(decoded_token.first['exp']).not_to be_nil
      expect(decoded_token.first['organization_id']).to eq @user.organization_id
      expect(decoded_token.first['role']).to eq @user.role
    end

  end

  context 'try to authenticate with invalid credential data' do
    before(:all) do
      @json_params = FactoryBot.build(:authenticate_json,
        email: "#{@user.email}.co",
        password: "#{@user.password}-invalid").marshal_dump.as_json
      @result = Authentication::Operations::GenerateToken.(params: @json_params)
    end

    it 'should be a failure' do
      expect(@result.failure?).to be_truthy
    end

    it 'should not set the current_user' do
      expect(@result['current_user']).to be_nil
    end

    it 'should not set the jwt_token' do
      expect(@result['jwt_token']).to be_nil
    end
  end

  context 'try to authenticate with unconfirmed user' do
    before(:all) do
      @json_params = FactoryBot.build(:authenticate_json,
        email: @user.email,
        password: @user.password).marshal_dump.as_json
      @user.status = 'unconfirmed'
      @user.save!
      @result = Authentication::Operations::GenerateToken.(params: @json_params)
    end

    it 'should be a failure' do
      expect(@result.failure?).to be_truthy
    end

    it 'should not set the current_user' do
      expect(@result['current_user']).to be_nil
    end

    it 'should not set the jwt_token' do
      expect(@result['jwt_token']).to be_nil
    end
  end

end
