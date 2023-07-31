require "rails_helper"

describe Api::SlotsController, type: :controller do
  describe "#create" do
    let!(:user) { create(:user) }

    before { sign_in user }

    subject { post :create, params: {code: "A1", name: "test"}, format: :json }
    it do
      expect do
        is_expected.to have_http_status(:ok)
      end.to(change(Slot, :count).by(1))
    end

    it do
      travel(0) do
        subject
        expect(response.body).to eq({uuid: Slot.first.uuid,
                                     code: "A1",
                                     name: "test",
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
    context ".search" do
      let!(:slot) { create(:slot, user: user, code: "XXX") }
      subject { get :index, params: {code: "X"}, format: :json }
      it do
        subject
        expect(response.body).to eq([{uuid: slot.uuid,
                                      code: slot.code,
                                      name: slot.name,
                                      parent_id: nil,
                                      created_at: slot.created_at,
                                      updated_at: slot.updated_at}].to_json)
      end
    end
  end
  describe "#root_slots" do
    let!(:user) { create(:user) }
    let!(:root_slot) { create(:slot, user: user, code: "ZZZ") }
    let!(:parent_slot) { create(:slot, user: user, code: "XXX", parent_id: root_slot.id) }
    let!(:child_slot) { create(:slot, user: user, code: "YYY", parent_id: parent_slot.id) }

    before { sign_in user }

    subject { get :root_slots, params: nil, format: :json }
    it do
      subject
      expect(response.body).to eq([{uuid: root_slot.uuid,
                                    code: root_slot.code,
                                    name: root_slot.name,
                                    parent_id: nil,
                                    created_at: root_slot.created_at,
                                    updated_at: root_slot.updated_at}].to_json)
    end
  end
  describe "#show" do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:slots) { create_list(:slot, 3, user: user) }
    before { sign_in user }
    after(:each) { sign_out user }

    subject { get :show, params: {id: user.slots.first.uuid}, format: :json }
    it do
      travel(0) do
        subject
        expect(response.body).to eq({uuid: user.slots.first.uuid,
                                     code: user.slots.first.code,
                                     name: user.slots.first.name,
                                     parent_id: nil,
                                     created_at: user.slots.first.created_at,
                                     updated_at: user.slots.first.updated_at}.to_json)
      end
    end
    context "with items" do
      let(:user3) { create(:user) }
      let!(:slot_with_items) { create(:slot_with_items, user: user3) }
      before { sign_in user3 }
      subject { get :show, params: {id: slot_with_items.uuid, with_items: "true"}, format: :json }
      it do
        subject
        expect(response.body)
          .to eq(Slot::SlotSerializer.new(slot_with_items, {with_items: "true"}).execute.to_json)
      end
    end
    context "with slots" do
      let(:user3) { create(:user) }
      let!(:slot_with_slots) { create(:slot_with_slots, user: user3) }
      before { sign_in user3 }
      subject { get :show, params: {id: slot_with_slots.uuid, with_child_slots: "true"}, format: :json }
      it do
        subject
        expect(response.body)
          .to eq(Slot::SlotSerializer.new(slot_with_slots, {with_child_slots: "true"}).execute.to_json)
      end
    end
    context "when not signed in" do
      before { sign_out user }
      subject { get :show, params: {id: user.slots.first.uuid}, format: :json }
      it { is_expected.to have_http_status(401) }
    end
  end
end
