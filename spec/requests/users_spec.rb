require 'swagger_helper'

RSpec.describe 'users', type: :request do
  let(:cards) { create_cards}
  let(:users) { create_users}

  path '/signup' do
    post('create user') do

      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string },
              password: { type: :string },
            }
          }
        },
        required: [ 'first_name', 'last_name', 'email', 'password' ]
      }

      response(200, 'successful') do
        let(:user) { { user: { first_name: 'John', last_name: 'Doe', email: 'johndoe@gmail.com', password: '123456' } }}

        run_test! do |response|
          data = JSON.parse(response.body)
          data = data['user']
          expect(data['first_name']).to eql('John')
          expect(data['last_name']).to eql('Doe')
          expect(data['email']).to eql('johndoe@gmail.com')
          expect(data['token']).not_to be_nil
        end
      end
    end
  end

  path '/login' do
    before do
      users
    end

    post('login user') do
      produces 'application/json'
      consumes 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
            }
          }  
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'successful') do
        let(:user) { { user: { email: 'johndoe@gmail.com', password: '123123' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          data = data['user']

          expect(data['first_name']).to eql('John')
          expect(data['last_name']).to eql('Doe')
          expect(data['email']).to eql('johndoe@gmail.com')
          expect(data['token']).not_to be_nil
        end
      end
    end
  end
end