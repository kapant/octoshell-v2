module Pack

  require 'main_spec_helper'


  describe "Pack::Access and Version expired testing" do

    it "marks expired versions and accesses as expired" do
      @access=access_with_status_without_validation(status: "allowed",end_lic: Date.yesterday.to_s)
      @version=build(:version,end_lic: Date.yesterday.to_s)
      @version.save(:validate => false)
      expect(@access.reload.status).to eq "allowed"
      ::Pack::PackWorker.perform_async(:expired)
      expect(@access.reload.status).to eq "expired"
    end
  end
end
