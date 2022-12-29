# frozen_string_literal: true

require "rails_helper"

describe Users::PasswordsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  let!(:user) { create(:user) }
  describe "password" do
    context "#create" do
      subject { post(:create, params: {user: {email: user.email}}, format: :json) }
      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON[subject.body]["reset_password_token"]).to be_present }
    end
    context "#update" do
      subject {
        post(:update, params: {user: {
          reset_password_token: "q_p_NoxSQ8RjX54HjNYA",
          password: "newpassword",
          password_confirmation: "newpassword"
        }}, format: :json)
      }

      it {
        pp(subject)
      }
    end
  end
end
