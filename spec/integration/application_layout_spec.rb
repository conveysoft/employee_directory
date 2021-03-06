require 'spec_helper'

describe "Application layout" do

  describe "navigation and page titles" do
    let(:company_name) { Rails.configuration.company_name }
    let(:application_name) { Rails.configuration.application_name }

    it "shows the company name in the navigation bar" do
      visit root_url
      expect(page).to have_selector('div.navbar.navbar-default')
      expect(page).to have_selector('a.navbar-brand', text: company_name)
    end

    it "shows the application name in the page header" do
      visit root_url
      within('div.page-header') { expect(page).to have_selector('h1',
                                  text: application_name) }
    end

    it "shows the application name in the page title" do
      visit root_url
      expect(page).to have_title(application_name)
    end
  end

  describe "navigation menu" do
    let(:user_to_log_in) { create :user, password: 'letmein',
                                  password_confirmation: 'letmein',
                                  admin: true }

    context "when logged out" do
      before { visit root_path }

      context "and clicking the Login link" do
        before { click_link 'Login' }

        it_should_behave_like 'the login page'
        it_should_behave_like 'all pages with logged out users'
      end
    end

    context "when logged in" do
      before { log_in_user(user_to_log_in) }

      context "and clicking the Directory link" do
        before { click_link 'Directory' }

        it_should_behave_like 'the directory page'
      end

      context "and clicking the Edit My Profile link" do
        before { click_link 'Edit My Profile' }

        it "shows the edit current user page" do
          expect(page).to have_selector('legend', text: 'Edit User')
        end

        it "shows the current user's name" do
          expect(find_field('user_first_name').value).to eq(user_to_log_in.first_name)
        end
      end

      context "and clicking the Users link" do
        before { click_link 'Users' }

        it_should_behave_like 'the user maintenance page'
      end

      context "and clicking the Departments link" do
        before { click_link 'Departments' }

        it "shows the department maintenance page" do
          expect(page).to have_selector('h3.panel-title',
                                        text: 'Department Maintenance')
        end

        it "shows the Maintenance link as active" do
          expect(page).to have_selector('li.active', text: 'Maintenance')
        end
      end

      context "and clicking the Logout link" do
        before { click_link 'Logout' }

        it "returns to the user directory screen" do
          expect(page).to have_selector('th', text: 'Last Name')
        end

        it "does not have the edit or delete links" do
          expect(page).not_to have_selector('ul.user-actions')
        end

        it_should_behave_like 'all pages with logged out users'
      end
    end
  end
end
