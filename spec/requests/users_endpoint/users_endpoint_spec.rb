require "rails_helper"

RSpec.describe "User Endpoints - v1/users", type: :request do
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

    # Create some users
    @organization2 = setup_organization
    @user1 = FactoryBot.create(:user, organization: @organization)
    @user2 = FactoryBot.create(:user, organization: @organization)
    @user3 = FactoryBot.create(:user, organization: @organization2)
  end

  context 'Other' do
    context 'List' do
      context 'roles' do
        shared_examples_for 'list' do
          it 'should return status 200' do
            expect(response.status).to eq 200
          end

          it 'should return the users as json' do
            body = response.parsed_body
            res = body['resource']

            expect(body['total_results']).to eq @organization.users.count
          end
        end

        context 'as root' do
          before(:all) do
            @user = @root
            get_json @endpoint, {}, @root_token
          end

          it_behaves_like 'list'
        end

        context 'as admin' do
          before(:all) do
            @user = @admin
            get_json @endpoint, {}, @admin_token
          end

          it_behaves_like 'list'
        end

        context 'as user' do
          before(:all) do
            get_json @endpoint, {}, @user_token
          end

          it 'should return status 403' do
            expect(response.status).to eq 403
          end
        end
      end
    end

    context 'List Internal' do
      context 'roles' do
        before(:all) do
          @endpoint = '/v1/users/internal'
        end

        shared_examples_for 'list_internal' do
          it 'should return status 200' do
            expect(response.status).to eq 200
          end

          it 'should return the internal users as json' do
            body = response.parsed_body
            res = body['resource']

            expect(body['total_results']).to eq @organization.users.where(role: ['root', 'admin', 'user']).count
          end
        end

        context 'as root' do
          before(:all) do
            @user = @root
            get_json @endpoint, {}, @root_token
          end

          it_behaves_like 'list_internal'
        end

        context 'as admin' do
          before(:all) do
            @user = @admin
            get_json @endpoint, {}, @admin_token
          end

          it_behaves_like 'list_internal'
        end

        context 'as user' do
          before(:all) do
            get_json @endpoint, {}, @user_token
          end

          it 'should return status 403' do
            expect(response.status).to eq 403
          end
        end
      end
    end
  end
end
