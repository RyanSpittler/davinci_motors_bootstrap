class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy, :claim, :unclaim]

  # GET /cars
  # GET /cars.json
  def index
    @cars = Car.where(user: nil)
  end

  def my_cars
    @cars = Car.where(user: current_user)
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: "#{@car.year} #{@car.make} #{@car.model} created." }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: "#{@car.year} #{@car.make} #{@car.model} updated." }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to my_cars_url, notice: 'Car was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def claim
    if current_user
      current_user.cars << @car
      redirect_to root_path, notice: "#{@car.make} #{@car.model} has been moved to your inventory."
    end
  end

  def unclaim
    if current_user
      @car.user = nil
      @car.save
      redirect_to my_cars_path, notice: "#{@car.make} #{@car.model} has been removed from your inventory."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:make, :model, :year, :price)
    end
end
