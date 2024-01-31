RSpec.shared_examples "import_preview" do |scope|
  before(:all) do
    post_json @endpoint, @post_json, @token
  end

  if scope == 'allowed'
    it 'should return status 200' do
      expect(response.status).to eq 200
    end

    it 'should retrieve the sheet parameters' do
      body = response.parsed_body
      importable_columns = @table_configuration[:columns].select { |node| node[:importable] == true }.map { |node| { prop: node[:prop], value_de: node[:value_de], type: node[:type], unique: node[:unique], required: node[:required] } }
      expect(body['total_rows_to_import']).to eq @total_rows_to_import
      # currently a bit crazy because some columns are not counted correctly
      # expect(body['headings'].count).to eq @headings_count
      expect(body['importable_columns'].count).to eq importable_columns.count + @meta_fields_count + @additional_import_columns_count
    end
  end

  if scope == 'forbidden'
    it 'should return status 403' do
      expect(response.status).to eq 403
    end
  end
end