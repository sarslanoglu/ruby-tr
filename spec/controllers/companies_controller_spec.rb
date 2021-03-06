require 'spec_helper'

RSpec.describe CompaniesController, type: :controller do
  context '#index' do
    before do
      FactoryBot.create_list :company, 10, published: true
      get :index
    end

    it 'should be success' do
      expect(response).to be_successful
    end

    it 'should be have 10 company' do
      expect(assigns(:companies).count).to eq 10
    end
  end

  context '#new' do
    before do
      user = FactoryBot.create :user
      sign_in user
    end

    it 'should be success' do
      get :new
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  context '#create without user' do
    before do
      post :create
    end

    it 'should be redirect to new_user_session path with notice danger' do
      expect(controller).to set_flash[:alert]
      expect(response).to redirect_to new_user_session_path
    end
  end

  context '#create with user' do
    before do
      user = FactoryBot.create :user
      sign_in user
      post :create, params: { company: { title: 'a company',
                                         sector: 'a sector',
                                         url: 'http://example.com',
                                         city: 'a city' } }
    end

    it 'should be redirect to companies_path with notice flash' do
      expect(controller).to set_flash[:notice]
      expect(response).to redirect_to companies_path
    end
  end
end
