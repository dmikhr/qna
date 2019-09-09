shared_examples_for 'API response successful' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'returns list of items' do
  it 'returns list of items' do
    item_ids = items.map { |item| item.id }

    json_items.each do |item|
      expect(item_ids).to include(item['id'])
    end
  end
end

shared_examples_for 'returns all public fields' do
  it 'returns all public fields' do
    json_items.zip(items).each do |json_item, item|
      public_fields.each do |attr|
        expect(json_item[attr]).to eq item.send(attr).as_json
      end
    end
  end
end

shared_examples_for 'number of items match' do
  it 'number of items match' do
    expect(json_items.size).to eq items.size
  end
end
