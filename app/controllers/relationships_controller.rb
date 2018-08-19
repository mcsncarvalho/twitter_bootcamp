class RelationshipsController < ApplicationController
    def create
        other_user = User.find(params["id"])
        if current_user.following?(other_user)
            redirect_to user_path(id:params["id"]), alert: "Já está seguindo #{other_user.email}!"
            return false
        end

        if current_user.follow!other_user
            redirect_to user_path(id:params["id"]), notice: 'Seguindo!'
        else
            redirect_to user_path(id:params["id"]), alert: 'Não foi possivel seguir!'
        end
    end

    def destroy
        other_user = User.find(params["id"])
        current_user.unfollow!(other_user)
        redirect_to user_path(id:params["id"]), notice: 'Parou de seguir!'
    end
end
