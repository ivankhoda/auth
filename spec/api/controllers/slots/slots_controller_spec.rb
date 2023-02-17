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
        expect(response.body).to eq({ uuid: Slot.first.uuid,
                                      code: "A1",
                                      name: "test",
                                      parent_id: nil,
                                      created_at: Time.now.utc,
                                      updated_at: Time.now.utc }.to_json)
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

    subject { get :show, params: { id: user.slots.first.uuid }, format: :json }
    it do
      travel(0) do
        subject
        expect(response.body).to eq({ uuid: user.slots.first.uuid,
                                      code: user.slots.first.code,
                                      name: user.slots.first.name,
                                      parent_id: nil,
                                      created_at: user.slots.first.created_at,
                                      updated_at: user.slots.first.updated_at }.to_json)
      end
    end
  end
end
