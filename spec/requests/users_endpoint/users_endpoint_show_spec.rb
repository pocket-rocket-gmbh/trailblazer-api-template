require "rails_helper"

RSpec.describe "Users Endpoints - v1/users", type: :request do
  before(:all) do
    @endpoint = '/v1/users'
    @organization = setup_organization

    # setup users
    @root       = setup_user_root(@organization)
    @admin      = setup_user_admin(@organization)
    @user       = setup_user(@organization)

    # Login users to get tokens
    @root_token = login(@root.email, @root.password)
    @admin_token = login(@admin.email, @admin.password)
    @user_token = login(@user.email, @user.password)

    # sample data
    @organization2 = setup_organization
    @user1 = FactoryBot.create(:user, organization: @organization)
    @user2 = FactoryBot.create(:user, organization: @organization)
    @user_from_different_organization = FactoryBot.create(:user, organization: @organization2)
  end

  context 'CRUD' do
    context 'Show' do
      context 'roles' do
        shared_examples_for 'show' do
          it 'should return status 200' do
            expect(response.status).to eq 200
          end

          it 'should return the order as json' do
            body = response.parsed_body
            res = body['resource']

            expect(res['id']).to eq @user.id
            expect(res['firstname']).to eq @user.firstname
            expect(res['lastname']).to eq @user.lastname
            expect(res['email']).to eq @user.email
            expect(res['role']).to eq @user.role
            expect(res['created_at']).not_to be_nil
            expect(res['updated_at']).not_to be_nil
          end
        end

        context 'as root' do
          describe 'from same organization' do
            before(:all) do
              @user = @user1
              @endpoint = "#{@endpoint}/#{@user.id}"
              get_json @endpoint, {}, @root_token
            end

            it_behaves_like 'show'
          end

          describe 'from different organization' do
            before(:all) do
              @user = @user_from_different_organization
              @endpoint = "#{@endpoint}/#{@user.id}"
              get_json @endpoint, {}, @root_token
            end

            it_behaves_like 'show'
          end
        end

        context 'as admin' do
          describe 'from same organization' do
            before(:all) do
              @user = @user1
              @endpoint = "#{@endpoint}/#{@user.id}"
              get_json @endpoint, {}, @admin_token
            end

            it_behaves_like 'show'
          end

          describe 'from different organization' do
            before(:all) do
              @user = @user_from_different_organization
              @endpoint = "#{@endpoint}/#{@user.id}"
              get_json @endpoint, {}, @admin_token
            end

            it 'should return status 404' do
              expect(response.status).to eq 404
            end
          end
        end

        context 'as user' do
          describe 'own user' do
            before(:all) do
              @endpoint = "#{@endpoint}/#{@user.id}"
              get_json @endpoint, {}, @user_token
            end

            it_behaves_like 'show'
          end

          describe 'other user' do
            before(:all) do
              @user = @user1
              @endpoint = "#{@endpoint}/#{@user.id}"
              get_json @endpoint, {}, @user_token
            end

            it 'should return status 404' do
              expect(response.status).to eq 404
            end
          end
        end
      end
    end
  end
end
