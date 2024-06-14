require 'rails_helper'

RSpec.describe 'Users Endpoints - v1/users', type: :request do
  describe '#get_geolocation' do
    # setup - authenticate and user
    before(:all) { @setup = setup_specs('v1', 'organizations') }

    # We need to find the user again,
    # as we would like to update them for testing
    let(:user) { User.find(@setup[:user].id) }
    let(:geocoder_config) { Geocoder.configure(lookup: :test) }

    # endpoint
    let(:action) { get_json "/v1/users/#{user.id}/geolocation", {}, @setup[:root_token] }

    context 'with happy path' do
      let(:lat_st_wendel) { 49.4638241 }
      let(:long_st_wendel) { 7.192195798522578 }
      let(:lat_hamburg) { 53.554066199999994 }
      let(:long_hamburg) { 9.931532509050726 }

      # stub geocoder api calls
      before do
        geocoder_config
        Geocoder::Lookup::Test.add_stub('66606, DE',
                                        [{'coordinates': [lat_st_wendel, long_st_wendel]}])
        Geocoder::Lookup::Test.add_stub('22765, DE',
                                        [{'coordinates': [lat_hamburg, long_hamburg]}])
      end

      it 'return status 200' do
        expect(action).to eq 200
      end

      context 'update user' do
        it 'with coordinate latitude' do
          expect { action }.to change { user.reload.latitude }.from(nil).to(lat_st_wendel)
        end

        it 'with coordinate longitude' do
          expect { action }.to change { user.reload.longitude }.from(nil).to(long_st_wendel)
        end

        it 'with coordinate latitude when address is changed' do
          user.update(zip_code: '22765', city: 'Hamburg', latitude: lat_st_wendel, longitude: long_st_wendel)
          expect { action }.to change { user.reload.latitude }.from(lat_st_wendel).to(lat_hamburg)
        end

        it 'with coordinate longitude when address is changed' do
          user.update(zip_code: '22765', city: 'Hamburg', latitude: lat_st_wendel, longitude: long_st_wendel)
          expect { action }.to change { user.reload.longitude }.from(long_st_wendel).to(long_hamburg)
        end
      end
    end

    context 'with unhappy path' do
      it 'return status 401 - not authenticated' do
        action = get_json "/v1/users/#{user.id}/geolocation", {}
        expect(action).to eq 401
      end

      it 'return status 422 - empty zip_code' do
        user.update(zip_code: '')
        expect(action).to eq 422
      end

      it 'return status 422 - wrong zip_code' do
        geocoder_config
        Geocoder::Lookup::Test.add_stub("wasdwasd, DE", [])

        user.update(zip_code: 'wasdwasd')
        expect(action).to eq 422
      end
    end
  end
end