# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authors' do
  let(:headers) { { 'Accept' => JSONAPI::MEDIA_TYPE, 'Content-Type' => JSONAPI::MEDIA_TYPE } }

  before do
    author = create(:author)
    create(:course, author: author)
  end

  describe 'GET #authors' do
    context 'when requesting a list of authors' do
      before do
        get authors_url, headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct authors' do
        expect(json_parsed[:data].size).to eq(User.where(is_author: true).count)
      end

      it 'returns correct relationship' do
        expect(json_parsed[:data].first[:relationships].key?(:'authored-courses')).to be true
      end
    end

    context 'when requesting a list of courses authored by the author' do
      let(:author) { User.find_by(is_author: true) }

      before do
        get author_related_authored_courses_url(author_id: author.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct courses' do
        expect(json_parsed[:data].size).to eq(author.authored_courses.count)
      end
    end
  end

  describe 'POST #authors' do
    context 'when creating a author' do
      let(:valid_params) do
        '{"data":{"type":"authors","attributes":{"name":"Tttest","email":"tttest@mail.com"}}}'
      end

      before do
        post authors_url, headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct courses' do
        expect(json_parsed[:data][:attributes][:name]).to eq('Tttest')
      end
    end
  end

  describe 'PUT #author' do
    context 'when updating a author' do
      let(:author) { User.find_by(is_author: true) }
      let(:valid_params) do
        "{\"data\":{\"id\":#{author.id},\"type\":\"authors\",\"attributes\":{\"name\":\"TTnew\"}}}"
      end

      before do
        put author_url(id: author.id), headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns updated author' do
        expect(json_parsed[:data][:attributes][:name]).to eq('TTnew')
      end
    end
  end

  describe 'DELETE #author' do
    context 'when deleting a author' do
      let(:author) { User.find_by(is_author: true) }

      before do
        delete author_url(id: author.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
