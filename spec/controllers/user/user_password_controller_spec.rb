# frozen_string_literal: true

require "rails_helper"

describe Users::PasswordsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  let!(:user) { create(:user) }
  describe "password" do
    describe "#create" do
      subject { post(:create, params: {user: {email: user.email}}, format: :json) }
      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON[subject.body]["reset_password_token"]).to be_present }
    end
    describe "#update" do
      context "when successful" do
        let(:request) { post(:create, params: {user: {email: user.email}}, format: :json) }

        subject {
          post(:update, params: {user: {
            reset_password_token: JSON(request.body)["reset_password_token"],
            password: "newpassword",
            password_confirmation: "newpassword"
          }}, format: :json)
        }

        it do
          expect(JSON[subject.body]["success"]).to eq(true)
          expect(JSON[subject.body]["user"]["email"]).to eq(user.email)
          expect(JSON[subject.body]["user"]["id"]).to eq(user.id)
        end
      end
      context "when not succesful" do
        subject {
          post(:update, params: {user: {
            reset_password_token: nil,
            password: "newpassword",
            password_confirmation: "newpassword"
          }}, format: :json)
        }
        it do
          expect(JSON[subject.body]["success"]).to eq(false)
          expect(JSON[subject.body]["message"]["reset_password_token"]).to eq(["can't be blank"])
        end
      end
    end
  end
end
