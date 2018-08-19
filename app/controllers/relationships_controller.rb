class RelationshipsController < ApplicationController
    def create
        @user = User.find(params["id"])

        if @user.id == current_user.id
            redirect_to user_path(id:params["id"]), alert: "Não pode seguir você mesmo!"
            return false
        end

        if current_user.following?(@user)
            redirect_to user_path(id:params["id"]), alert: "Já está seguindo #{@user.email}!"
        else 
            current_user.follow!@user
            redirect_to user_path(id:params["id"]), notice: 'Seguindo!'
        end
    end

    def destroy
        @user = User.find(params["id"])
        current_user.unfollow!(@user)
        redirect_to user_path(id:params["id"]), notice: 'Parou de seguir!'
    end
end
