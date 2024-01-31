require "rails_helper"

RSpec.describe "Organization Endpoints - v1/organizations", type: :request do
  describe '#update' do
    before(:all) do
      Organization.destroy_all
      @setup = setup_specs("v1", "organizations")
      @resource = FactoryBot.create(:organization)
      @resource_updated = FactoryBot.build(:organization)
      base64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
      @put_json = {
        name: @resource_updated.name,
        status: nil,
        file: base64
      }
    end
    context 'when data is valid' do
      before(:all) do
        @endpoint = "#{@setup[:endpoint]}/#{@resource.id}"
      end
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
        end
        include_examples "update", "allowed"
        it_behaves_like 'update'

        it 'should attach an image' do
          expect(@resource.image_url).not_to eq nil
          expect(@resource.image.attached?).to be_truthy
        end
      end

      context 'for scope admin' do
        before(:all) do
          @token = @setup[:admin_token]
        end
        include_examples "update", "forbidden"
        it_behaves_like 'update'
      end

      context 'for scope user' do
        before(:all) do
          @token = @setup[:user_token]
        end
        include_examples "update", "forbidden"
        it_behaves_like 'update'
      end
    end

    context 'when resource is not found' do
      before(:all) do
        @endpoint = "#{@setup[:endpoint]}/39754493857349875"
      end
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
        end
        include_examples "update", "not_found"
        it_behaves_like 'update'
      end
    end
  end
end