require "rails_helper"

RSpec.describe EventAttendeesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/event_attendees").to route_to("event_attendees#index")
    end

    it "routes to #show" do
      expect(get: "/event_attendees/1").to route_to("event_attendees#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/event_attendees").to route_to("event_attendees#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/event_attendees/1").to route_to("event_attendees#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/event_attendees/1").to route_to("event_attendees#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/event_attendees/1").to route_to("event_attendees#destroy", id: "1")
    end
  end
end
