require 'rails_helper'

RSpec.describe LandingpagesController, type: :controller do
  describe "GET #home" do
    before { get :home }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render app/views/landingpages/home.html.erb" do
      expect(response).to render_template :home
    end
  end

  describe "GET #about" do
    before { get :about }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render app/views/landingpages/about.html.erb" do
      expect(response).to render_template :about
    end
  end

  describe "GET #contact" do
    before { get :contact }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render app/views/landingpages/contact.html.erb" do
      expect(response).to render_template :contact
    end
  end

  describe "GET #help" do
    before { get :help }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render app/views/landingpages/help.html.erb" do
      expect(response).to render_template :help
    end
  end

  describe "GET #terms_of_use" do
    before { get :terms_of_use }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render app/views/landingpages/terms_of_use.html.erb" do
      expect(response).to render_template :terms_of_use
    end
  end
end
