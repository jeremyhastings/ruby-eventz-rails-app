class RegistrationsController < ApplicationController

  before_action :set_event

  def index
    #@event = Event.find(params[:event_id])
    @registrations = @event.registrations
  end

  def new
    #@event = Event.find(params[:event_id])
    @registration = @event.registrations.new
  end

  def create
    #@event = Event.find(params[:event_id])

    @registration = @event.registrations.new(registration_params)

    if @registration.save
      redirect_to event_registrations_url(@event), notice: "Thanks for registering!"
    else
      render :new
    end
  end

  private
  def registration_params
    params.require(:registration).permit(:name, :email, :how_heard)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
