class BoardsController < ApplicationController
  before_filter :require_login!

  def index
    @boards = current_user.boards

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @boards }
    end
  end

  def show
    @board = Board.find(params[:id])

    render json: @board
  end

  def create
    @board = current_user.boards.build(board_params)

    if @board.save
      render json: @board
    else
      render json: { errors: @board.errors.full_messages }, status: 422
    end
  end

  def update
    @board = Board.find(params[:id])
    @board.update_attributes(board_params)

    if @board.save
      render json: @board
    else
      render json: { errors: @board.errors.full_messages }, status: 422
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    render json: nil
  end


  private
  def board_params
    params.require(:board).permit(:title, :description)
  end
end
