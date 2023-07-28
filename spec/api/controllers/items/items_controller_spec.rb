describe Api::ItemsController, type: :controller do
  describe "#create" do
    let!(:user) { create(:user) }
    let!(:slot) { create(:slot, user: user) }

    before { sign_in user }

    subject { post :create, params: {code: "A1", name: "test", slot_code: slot.code}, format: :json }
    it { is_expected.to have_http_status(:ok) }
    it { expect { subject }.to change(Item, :count).by(1) }
    it do
      travel(0) do
        subject
        expect(response.body).to eq({id: 3,
                                     code: "A1",
                                     name: "test",
                                     user_id: user.id,
                                     slot_id: slot.id,
                                     created_at: Time.now.utc,
                                     updated_at: Time.now.utc}.to_json)
      end
    end
  end
  describe "#index" do
    let!(:user) { create(:user) }
    let!(:slot) { create(:slot, user: user) }
    let!(:items) { create_list(:item, 3, user: user, slot: slot) }
    before { sign_in user }

    subject { get :index, params: nil, format: :json }
    it do
      subject
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
  describe "#show" do
    let!(:user) { create(:user) }
    let!(:slot) { create(:slot, user: user) }
    let!(:items) { create_list(:item, 3, user: user, slot: slot) }
    before { sign_in user }

    subject { get :show, params: {id: user.items.first.id}, format: :json }
    it do
      travel(0) do
        subject
        expect(response.body).to eq({code: user.items.first.code,
                                     name: user.items.first.name,
                                     created_at: user.items.first.created_at,
                                     updated_at: user.items.first.updated_at,
                                     parent_slot: slot.name}.to_json)
      end
    end
    context ".with slot" do
      let!(:item) { create(:item, user: user, slot: slot) }
      subject { get :show, params: {id: item.id, with_slot: true}, format: :json }
      it do
        subject
        expect(response.body)
          .to eq(Item::ItemSerializer.new(item, {with_slot: "true"}).execute.to_json)
      end
    end
  end
end
