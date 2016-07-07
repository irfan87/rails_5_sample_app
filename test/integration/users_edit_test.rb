require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:irfan)
	end

	test "unsuccessful edit" do
		log_in_as(@user)
		get edit_user_path(@user)

		assert_template 'users/edit'

		patch user_path(@user), params: {
			user: {
				name: "",
				email: "foo@invalid",
				password: "foo",
				password_confirmation: "bar"
			}
		}

		assert_template 'users/edit'
	end

	test "successful edit" do
		log_in_as(@user)
		get edit_user_path(@user)

		assert_template 'users/edit'

		name = "John Doe"
		email = "johndoe@example.com"

		patch user_path(@user), params: {
			user: {
				name: name,
				email: email,
				password: "",
				password_confirmation: ""
			}
		}

		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal name, @user.name
		assert_equal email, @user.email
	end

	test "successful edit with friendly forwarding" do
		get edit_user_path(@user)
		log_in_as(@user)
		assert_redirected_to edit_user_path(@user)
		name = "John Doe"
		email = "johndoe@example.com"

		patch user_path(@user), params: {user: {
				name: name,
				email: email,
				passord: "",
				password_confirmation: ""
			}
		}

		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal name, @user.name
		assert_equal email, @user.email
	end
end