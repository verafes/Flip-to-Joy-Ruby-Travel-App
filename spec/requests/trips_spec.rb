require 'rails_helper'

RSpec.describe "Trips", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/trips/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/trips/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/trips/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/trips/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/trips/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/trips/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destro" do
    it "returns http success" do
      get "/trips/destro"
      expect(response).to have_http_status(:success)
    end
  end

end
