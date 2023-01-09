# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courses' do
  let(:headers) { { 'Accept' => JSONAPI::MEDIA_TYPE, 'Content-Type' => JSONAPI::MEDIA_TYPE } }

  before do
    author = create(:author)
    create(:author)
    talent = create(:talent)
    create(:talent)
    course = create(:course, author: author)
    create(:talent_course, talent: talent, course: course)
  end

  describe 'GET #courses' do
    context 'when requesting a list of courses' do
      before do
        get courses_url, headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct courses' do
        expect(json_parsed[:data].size).to eq(Course.count)
      end

      it 'returns correct first relationship' do
        expect(json_parsed[:data].first[:relationships].key?(:author)).to be true
      end

      it 'returns correct second relationship' do
        expect(json_parsed[:data].first[:relationships].key?(:talents)).to be true
      end
    end

    context 'when requesting a list of talents in the course' do
      let(:course) { Course.take }

      before do
        get course_related_talents_url(course_id: course.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct talents' do
        expect(json_parsed[:data].size).to eq(course.talents.count)
      end
    end

    context 'when requesting an author of the course' do
      let(:course) { Course.take }

      before do
        get course_related_author_url(course_id: course.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct author' do
        expect(json_parsed[:data][:attributes][:name]).to eq(course.author.name)
      end
    end
  end

  describe 'POST #courses' do
    context 'when creating a course' do
      let(:author) { User.find_by(is_author: true) }
      let(:valid_params) do
        '{"data":{"type":"courses","relationships":{"author":{"data":{"type":"users","id":' \
          "\"#{author.id}\"}}},\"attributes\":{\"title\":\"Tttest\"}}}"
      end

      before do
        post courses_url, headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct courses' do
        expect(json_parsed[:data][:attributes][:title]).to eq('Tttest')
      end
    end
  end

  describe 'PUT #course' do
    context 'when updating a course' do
      let(:course) { Course.take }
      let(:valid_params) do
        "{\"data\":{\"id\":#{course.id},\"type\":\"courses\",\"attributes\":{\"title\":\"TTnew\"}}}"
      end

      before do
        put course_url(id: course.id), headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns updated course' do
        expect(json_parsed[:data][:attributes][:title]).to eq('TTnew')
      end
    end
  end

  describe 'DELETE #course' do
    context 'when deleting a course' do
      let(:course) { Course.take }

      before do
        delete course_url(id: course.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
