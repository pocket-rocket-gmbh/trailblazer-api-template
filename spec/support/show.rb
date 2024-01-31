RSpec.shared_examples "show" do |scope|
  before(:all) do
    get_json @endpoint, {}, @token
  end

  if scope == 'allowed'
    it 'should return status 200' do
      expect(response.status).to eq 200
    end

    it 'should list the parsed body as hash' do
      expect(parsed_response.class).to eq Hash
    end

    it 'should output the correct data' do
      resource = parsed_response["resource"]
      resource.keys.each do |key|
        if @resource[key]
          if @resource.column_for_attribute(key).type == :date
            expect(@resource[key].strftime('%Y-%m-%d')).to eq resource[key]
          elsif @resource.column_for_attribute(key).type == :time
            expect(@resource[key].strftime('%H:%M:%S')).to eq resource[key]
          elsif @resource[key].class == ActiveSupport::TimeWithZone
            expect(@resource[key].to_i).to eq resource[key].to_datetime.to_i
          elsif @resource[key].class == BigDecimal
            expect(@resource[key].to_f).to eq resource[key].to_f
          else
            expect(@resource[key]).to eq resource[key]
          end
        end
      end
    end

    it 'should include meta data in the parsed response' do
      expect(parsed_response["resource_url"]).not_to eq nil
      expect(parsed_response["retrieved_at"]).not_to eq nil
    end
  end

  if scope == 'forbidden'
    it 'should return status 403' do
      expect(response.status).to eq 403
    end
  end

  if scope == 'not_found'
    it 'should return status 404' do
      expect(response.status).to eq 404
    end
  end
end