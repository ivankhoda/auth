# frozen_string_literal: true

require "rails_helper"
require "json"

describe Users::SessionsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  let!(:user) { create(:user) }

  let(:url) { "login" }
  let(:params) do
    {
      user: {
        login: user.email,
        password: user.password
      }
    }
  end
  describe "login" do
    context "when params are correct" do
      subject { post(:create, params: {user: {email: "some@example.com", password: "AaBbCcDd"}}, format: :json) }

      it { expect(subject).to have_http_status(200) }

      it "returns JTW token in response body" do
        expect(JSON[subject.body]["jwt"]).to be_present
      end

      it "returns valid JWT token" do
        decoded_token = JWT.decode(JSON[subject.body]["jwt"], Rails.application.secret_key_base, true)
        expect(decoded_token).to be_present
      end
    end

    context "when login params are incorrect" do
      subject { post(:create, params: {user: {email: "not_exists@example.com", password: "AaBbCcDd"}}, format: :json) }

      it "returns unathorized status" do
        expect(subject.status).to eq 401
      end
    end
  end

  describe "logout" do
    before do
      sign_in(user)
    end
    subject { delete(:destroy) }
    it { pp(subject) }
  end
end

# RSpec.describe "DELETE /logout", type: :request do
#   let(:url) { "/users/logout" }
#
#   it "returns 204, no content" do
#     delete url
#     expect(response).to have_http_status(204)
#   end
# end
#
# RSpec.describe "POST /signup", type: :request do
#   let(:url) { "/users/signup" }
#   let(:params) do
#     {
#       user: {
#         username: "usertest2",
#         email: "usertest2@email.com",
#         password: "passwordtest123",
#         password_confirmation: "passwordtest123"
#       }
#     }
#   end
#
#   context "when user is unauthenticated" do
#     before {
#       post url,
#         params: params.to_json,
#         headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
#     }
#
#     it "returns 201" do
#       expect(response.status).to eq 201
#     end
#
#     it "returns a new user" do
#       expect(response).to have_http_status :created
#     end
#   end
#
#   context "when user already exists" do
#     before do
#       post url,
#         params: params.to_json,
#         headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
#
#       post url,
#         params: params.to_json,
#         headers: {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
#     end
#
#     it "returns bad request status" do
#       expect(response.status).to eq 400
#     end
#
#     it "returns validation errors" do
#       expect(response_body["errors"].first["title"]).to eq("Bad Request")
#     end
#   end
# end
