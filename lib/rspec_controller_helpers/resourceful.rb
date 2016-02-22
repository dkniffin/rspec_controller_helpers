RSpec.shared_examples_for 'a resourceful controller' do |model, raw_options|
  let(:options) { ({ endpoint_formats: {} }).merge(raw_options) }
  let(:symbol) { options[:symbol] || model.name.downcase.to_sym }
  let(:factory) { options[:factory] || symbol }

  let(:endpoints_to_test) do
    all = [:index, :new, :create, :show, :edit, :update, :delete]
    except = options[:except] || []
    options[:only] || (all - except)
  end

  let(:endpoint_formats) do
    endpoints_to_test
      .map{|t| { t => :html } }
      .reduce(:merge)
      .merge(options[:endpoint_formats])
  end

  let(:json_response) { JSON.parse(response.body) }

  describe "GET /<resource>" do
    let!(:objects) { create_list(factory, 3) }
    subject { get :index }

    it 'is successful' do
      if endpoints_to_test.include? :index
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the index page" do
      if endpoints_to_test.include? :index
        subject
        case endpoint_formats[:index]
        when :html
          expect(response).to render_template(:index)
        when :json
          expect(json_response.length).to eq(3)
        end
      end
    end
  end

  describe "GET /<resource>/new" do
    subject { get :new }

    it 'is successful' do
      if endpoints_to_test.include? :new
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the new page" do
      if endpoints_to_test.include? :new
        subject
        case endpoint_formats[:new]
        when :html
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "POST /<resource>" do
    let(:attributes) { attributes_for(factory) }
    subject { post :create, symbol => attributes }

    it "creates a new object" do
      if endpoints_to_test.include? :create
        expect { subject }.to change { model.count }.by(1)
      end
    end
  end

  describe "GET /<resource>/:id" do
    let(:object) { create(factory) }
    subject { get :show, id: object.id }

    it 'is successful' do
      if endpoints_to_test.include? :show
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the show page" do
      if endpoints_to_test.include? :show
        subject
        case endpoint_formats[:show]
        when :html
          expect(response).to render_template(:show)
        when :json
          # object.to_json
          attributes = attributes_for(factory).map{ |k, _| [k, object.send(k)] }.to_h
          expect(json_response).to eq(attributes)
        end
      end
    end
  end

  describe "GET /<resource>/:id/edit" do
    let(:object) { create(factory) }
    subject { get :edit, id: object.id }

    it 'is successful' do
      if endpoints_to_test.include? :edit
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    it "renders the edit page" do
      if endpoints_to_test.include? :edit
        subject
        case endpoint_formats[:edit]
        when :html
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "PATCH /<resource>/:id" do
    let(:object) { create(factory) }
    let(:new_attributes) { attributes_for(factory) }
    subject { patch :update, id: object.id, symbol => new_attributes }

    it "updates the object" do
      if endpoints_to_test.include? :update
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
      if endpoints_to_test.include? :destroy
        expect { subject }.to change { model.count }.by(-1)
      end
    end
  end
end
