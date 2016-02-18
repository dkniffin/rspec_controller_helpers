shared_examples_for 'a resourceful controller' do |model, raw_options|
  let(:options) { raw_options || {} }
  let(:symbol) { options[:symbol] || model.name.downcase.to_sym }
  let(:factory) { options[:factory] || symbol }

  let(:tests) do
    all = [:index, :new, :create, :show, :edit, :update, :delete]
    except = options[:except] || []
    options[:only] || (all - except)
  end

  describe "GET /<resource>" do
    let!(:objects) { create_list(factory, 3) }
    subject { get :index }

    it "renders the index page" do
      if tests.include? :index
        subject
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET /<resource>/new" do
    subject { get :new }

    it "renders the new page" do
      if tests.include? :new
        subject
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST /<resource>" do
    let(:attributes) { attributes_for(factory) }
    subject { post :create, symbol => attributes }

    it "creates a new object" do
      if tests.include? :create
        expect { subject }.to change { model.count }.by(1)
      end
    end
  end

  describe "GET /<resource>/:id" do
    let(:object) { create(factory) }
    subject { get :show, id: object.id }

    it "renders the show page" do
      if tests.include? :show
        subject
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET /<resource>/:id/edit" do
    let(:object) { create(factory) }
    subject { get :edit, id: object.id }

    it "renders the edit page" do
      if tests.include? :edit
        subject
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH /<resource>/:id" do
    let(:object) { create(factory) }
    let(:new_attributes) { attributes_for(factory) }
    subject { patch :update, id: object.id, symbol => new_attributes }

    it "updates the object" do
      if tests.include? :update
        subject
        object.reload
        new_attributes.each do |k, v|
          expect(object.send(k)).to eq(v)
        end
      end
    end
  end

  describe "DELETE /<resource>/:id" do
    let!(:object) { create(factory) }
    subject { delete :destroy, id: object.id }

    it "deletes the object" do
      if tests.include? :destroy
        expect { subject }.to change { model.count }.by(-1)
      end
    end
  end
end
