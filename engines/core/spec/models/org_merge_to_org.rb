module Core
  require 'main_spec_helper'
  describe Organization do
    describe "#merge_with_organization" do
      before (:each) do
        @organization = create(:organization)
        @organization2 = create(:organization)
      end
      it "works successfully" do
        @result, @message = @organization.merge_with_organization(@organization2.id)
        expect(@result).to eq true
        expect(@message).to eq nil
        expect(Organization.all).to eq [@organization2]
        expect(OrganizationDepartment.all).to eq []

      end

      it "merges organization with existing departments" do
        @department = create(:organization_department, organization: @organization)
        @result, @message = @organization.merge_with_organization(@organization2.id)
        expect(@result).to eq true
        expect(@message).to eq nil
        expect(Organization.all).to match_array [@organization2,@organization]
        expect(OrganizationDepartment.first.organization).to eq [@organization2]
      end

      it "destroys organization  and changes associated objects " do
        @project = create_project(organization: @organization)
        @user = create_admin
        @organization.employments.create! user: @user,
                                          organization: @organization
        @member = @project.members.create!(user: @user,
                                           organization: @organization)
        @result, @message = @organization.merge_with_organization(@organization2.id)
        expect(@result).to eq true
        expect(@message).to eq nil
        expect(Organization.all).to eq [@organization2]
        expect(OrganizationDepartment.all).to eq []
        expect(Employment.first.organization_department).to eq nil
        expect(Employment.first.organization).to eq @organization2
        expect(Member.find_by(user_id: @user.id).organization).to eq @organization2
        expect(Member.find_by(user_id: @user.id).organization_department)
          .to eq nil
        @project.reload
        expect(@project.organization).to eq @organization2
        expect(@project.organization_department)
          .to eq nil
      end


      it "destroys organization  and changes associated objects " do
        dep = create(:organization_department,organization: @organization)
        @project = create_project(organization: @organization,organization_department: dep)
        @user = create_admin
        @organization.employments.create! user: @user,
                                          organization: @organization
        @member = @project.members.create!(user: @user,
                                           organization: @organization)
        @result, @message = @organization.merge_with_organization!(@organization2.id, true)
        expect(@result).to eq true
        expect(@message).to eq nil
        expect(Organization.all).to eq [@organization2]
        expect(OrganizationDepartment.all).to eq []
        expect(Employment.first.organization_department).to eq nil
        expect(Employment.first.organization).to eq @organization2
        expect(Member.find_by(user_id: @user.id).organization).to eq @organization2
        expect(Member.find_by(user_id: @user.id).organization_department)
          .to eq nil
        @project.reload
        expect(@project.organization).to eq @organization2
        expect(@project.organization_department)
          .to eq nil
      end


    end
  end
end
