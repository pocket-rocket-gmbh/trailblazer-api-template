require "rails_helper"

RSpec.describe "Organization Endpoints - v1/organizations", type: :request do
  describe '#create' do
    before(:all) do
      Organization.destroy_all
      @setup = setup_specs("v1", "organizations")
      @endpoint = @setup[:endpoint]
      @resource = FactoryBot.build(:organization)

      base64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="

      @post_json = {
        name: @resource.name,
        status: @resource.status,
        file: base64
      }
    end
    context 'when data is valid' do
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
        end
        include_examples "create", "allowed"
        it_behaves_like 'create'

        it 'should attach an image' do
          @new_organization = Organization.find parsed_response['resource']['id']
          expect(@new_organization.image_url).not_to eq nil
          expect(@new_organization.image.attached?).to be_truthy
        end
      end

      context 'for scope admin' do
        before(:all) do
          @token = @setup[:admin_token]
        end
        include_examples "create", "forbidden"
        it_behaves_like 'create'
      end

      context 'for scope user' do
        before(:all) do
          @token = @setup[:user_token]
        end
        include_examples "create", "forbidden"
        it_behaves_like 'create'
      end
    end
  end
end