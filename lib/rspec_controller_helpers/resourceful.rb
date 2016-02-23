RSpec.shared_examples_for 'a resourceful controller' do |model, raw_options|
  let(:default_options) do
    {
      only: [:index, :new, :create, :show, :edit, :update, :delete],
      except: [],
      formats: {} # They all default to :html
    }
  end
  let(:options) { default_options.merge(raw_options) }
  let(:model_name) { options[:model_name] || model.name.downcase.to_sym }
  let(:factory) { options[:factory] || model_name }
  let(:endpoints) { options[:only] - options[:except] }

  let(:formats) do
    endpoints
      .map { |t| { t => [:html] } }
      .reduce(:merge)
      .merge(options[:formats])
  end

  let(:json_response) { JSON.parse(response.body) }

  describe "GET /<resource>" do
    let!(:objects) { create_list(factory, 3) }
    subject { get :index }

    it 'is successful' do
      if endpoints.include? :index
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the index page" do
      if endpoints.include? :index
        subject
        if formats[:index].include? :html
          expect(response).to render_template(:index)
        end
        if formats[:index].include? :json
          expect(json_response.length).to eq(3)
        end
      end
    end
  end

  describe "GET /<resource>/new" do
    subject { get :new }

    it 'is successful' do
      if endpoints.include? :new
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the new page" do
      if endpoints.include? :new
        subject
        if formats[:new].include? :html
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "POST /<resource>" do
    let(:attributes) { attributes_for(factory) }
    subject { post :create, model_name => attributes }

    it "creates a new object" do
      if endpoints.include? :create
        expect { subject }.to change { model.count }.by(1)
      end
    end
  end

  describe "GET /<resource>/:id" do
    let(:object) { create(factory) }
    subject { get :show, id: object.id }

    it 'is successful' do
      if endpoints.include? :show
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the show page" do
      if endpoints.include? :show
        subject
        if formats[:show].include? :html
          expect(response).to render_template(:show)
        end
        if formats[:show].include? :json
          desired_attributes = attributes_for(factory).keys
          attributes = object.attributes.select { |k, _| desired_attributes.include?(k) }
          expect(json_response).to eq(attributes)
        end
      end
    end
  end

  describe "GET /<resource>/:id/edit" do
    let(:object) { create(factory) }
    subject { get :edit, id: object.id }

    it 'is successful' do
      if endpoints.include? :edit
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the edit page" do
      if endpoints.include? :edit
        subject
        if formats[:edit].include? :html
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "PATCH /<resource>/:id" do
    let(:object) { create(factory) }
    let(:new_attributes) { attributes_for(factory) }
    subject { patch :update, id: object.id, model_name => new_attributes }

    it "updates the object" do
      if endpoints.include? :update
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
      if endpoints.include? :destroy
        expect { subject }.to change { model.count }.by(-1)
      end
    end
  end
end
