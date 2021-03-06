class Admin::UsersController < Admin::AdminController
  def index
    @users = UserDecorator.decorate_collection(User.all)
  end

  def show
    @user = User.find(params[:id]).decorate
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Updated user"
      redirect_to [:admin, @user]
    else
      render 'edit', status: 400
    end
  end

  def promote
    @user = User.find(params[:id])
    @user.admin = true
    if @user.save
      flash[:success] = "Promoted"
      redirect_to [:admin, @user]
    else
      render 'show', status: 400
    end
  end

  def demote
    @user = User.find(params[:id])
    @user.admin = false
    if @user.save
      flash[:success] = "Demoted"
      redirect_to [:admin, @user]
    else
      render 'show', status: 400
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :email
    )
  end
end
