 class MessagesController < ApplicationController

  def index
    @messages = Message.all.order('created_at DESC').limit(6)
  end

  def create
    @message = Message.create!(message_params)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
