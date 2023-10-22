class AfterSignupController < ApplicationController
    include Wicked::Wizard
    # steps: :profile, :avatar, :finish
    # Asterisk means variable number of arguments
    # form_steps is from user.rb
    steps *User.form_steps
    def show
        @user = current_user
        case step
            when "sign_up"
                # .persisted check whether the @user object has been saved to the database or not
                skip_step if @user.persisted?
            when "set_address"
                @address = get_address
            when "find_users"
                @users = User.all
        end
    render_wizard
    end
    def update
        @user = current_user
        case step
            when "set_name"
                if @user.update(onboarding_params(step))
                    render_wizard @user
                else
                    puts @user.errors.full_messages # Add this line to check for errors
                    render_wizard @user, status: :unprocessable_entity
                end

            when "set_address"
                if @user.create_address(onboarding_params(step).except(:form_step))
                    render_wizard @user
                else
                    @address.destroy
                    render_wizard @user, status: :unprocessable_entity
                end
            end
    end
    private
    def get_address
        if @user.address.nil?
            Address.new
        else
            @user.address
        end
    end

    def finish_wizard_path
        root_path
    end
    def onboarding_params(step = "sign_up")
        case step
        when "set_name"
            params.require(:user).permit(:first_name, :last_name).merge(form_step: step)
        when "set_address"
            params.require(:address).permit(:street, :city, :state, :zip, :country).merge(form_step: step)
        end    
    end
end
