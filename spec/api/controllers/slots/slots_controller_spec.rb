require "rails_helper"

describe Api::SlotsController, type: :controller do
  describe "#create" do
    let!(:user) { create(:user) }
    before { sign_in user }

    subject { post :create, params: {code: "A1", name: "test"}, format: :json }
    it { is_expected.to have_http_status(:ok) }
    it { expect { subject }.to change(Slot, :count).by(1) }
    it do
      travel(0) do
        subject
        expect(response.body).to eq({id: 3,
                                     code: "A1",
                                     name: "test",
                                     user_id: user.id,
                                     parent_id: nil,
                                     created_at: Time.now.utc,
                                     updated_at: Time.now.utc}.to_json)
      end
    end
  end
  describe "#index" do
    let!(:user) { create(:user) }
    let!(:slots) { create_list(:slot, 3, user: user) }
    before { sign_in user }

    subject { get :index, params: nil, format: :json }
    it do
      subject
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
  describe "#show" do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:slots) { create_list(:slot, 3, user: user) }
    before { sign_in user }

    subject { get :show, params: {id: 1}, format: :json }
    it do
      subject
      pp(JSON.parse(response.body))
    end
  end
end
