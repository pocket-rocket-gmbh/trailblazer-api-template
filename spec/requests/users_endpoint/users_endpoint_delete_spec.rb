require "rails_helper"

RSpec.describe "Users Endpoints - v1/users", type: :request do
  before(:all) do
    @endpoint = '/v1/users'
    @organization = setup_organization
    @organization2 = setup_organization

    # setup users
    @root       = setup_user_root(@organization)
    @admin      = setup_user_admin(@organization)
    @user       = setup_user(@organization)

    # Login users to get tokens
    @root_token = login(@root.email, @root.password)
    @admin_token = login(@admin.email, @admin.password)
    @user_token = login(@user.email, @user.password)
  end

  context 'CRUD' do
    context 'Delete' do
      context 'roles' do
        shared_examples_for 'delete' do
          it 'should return status 204' do
            expect(response.status).to eq 204
          end

          it 'should delete the user' do
            expect(@organization.users.where(id: @user.id).count).to eq 0
          end
        end

        context 'as root' do
          describe 'from same organization' do
            before(:all) do
              @user = FactoryBot.create(:user, organization: @organization)
              @endpoint = "#{@endpoint}/#{@user.id}"
              delete_json @endpoint, {}, @root_token
            end

            it_behaves_like 'delete'
          end

          describe 'from different organization' do
            before(:all) do
              @user = FactoryBot.create(:user, organization: @organization2)
              @endpoint = "#{@endpoint}/#{@user.id}"
              delete_json @endpoint, {}, @root_token
            end

            it_behaves_like 'delete'
          end
        end

        context 'as admin' do
          describe 'from same organization' do
            before(:all) do
              @user = FactoryBot.create(:user, organization: @organization)
              @endpoint = "#{@endpoint}/#{@user.id}"
              delete_json @endpoint, {}, @admin_token
            end

            it_behaves_like 'delete'
          end

          describe 'from different organization' do
            before(:all) do
              @user = FactoryBot.create(:user, organization: @organization2)
              @endpoint = "#{@endpoint}/#{@user.id}"
              delete_json @endpoint, {}, @admin_token
            end

            it 'should return status 404' do
              expect(response.status).to eq 404
            end
          end
        end

        context 'as user' do
          before(:all) do
            @user = FactoryBot.create(:user, organization: @organization)
            @endpoint = "#{@endpoint}/#{@user.id}"
            delete_json @endpoint, {}, @user_token
          end

          it 'should return status 403' do
            expect(response.status).to eq 403
          end
        end
      end
    end
  end
end
