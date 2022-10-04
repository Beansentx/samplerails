class PasswordResetsController < ApplicationController
    before_action :usertype, only: [:edit, :update]
    def new
    end

    def create
        @user = User.find_by(email: params[:email])
        if @user.present?
            # Send email  
            PasswordMailer.with(user: @user).reset.deliver_now
        end
            redirect_to root_path, notice: "If an account with that email was found, we have sent a link to reset your password "
        end


        def edit
        rescue ActiveSupport::MessageVerifier::InvalidSignature
            redirect_to sign_in_path, alert: "Your token has expired, please try again."
        end

        def update
            if @user.update(password_params)
                redirect_to sign_in_path, notice: "Your password was reset successfully, please sign in"
            else
                render :edit
        end 
    end

    private
    
    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end

    def usertype
        @user = User.find_signed(params[:token], purpose: "password_reset")
    end
end