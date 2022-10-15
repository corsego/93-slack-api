class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # client = Slack::Web::Client.new
        # client.auth_test
        # client.chat_postMessage(channel: '#general', text: "#{@user.email} created", as_user: true)
        # client.chat_postMessage(channel: '#general', text: markdown_text(@user))

        filename = 'sample-image.png'
        file_path = Rails.root.join('app', 'assets', 'images', filename).to_s
        SlackClient.client.files_upload(
          channels: '#general',
          as_user: true,
          file: Faraday::UploadIO.new(file_path, 'image/png'),
          title: 'My Avatar',
          filename: filename,
          initial_comment: 'Attached a selfie.'
        )
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def markdown_text(user)
      <<~TEXT
      :white_check_mark: User created
      *email*: #{user.email}
      *name*: #{user.name}
      *phone*: #{user.phone}
      inline `code`
      ```
      code block
      ```
      https://app.slack.com/client/TBVTPMD0E/CBVKBBYNT
      TEXT
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :phone)
    end
end
