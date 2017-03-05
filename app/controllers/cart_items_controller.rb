class CartItemsController < ApplicationController

  def destroy
    @cart = current_cart
    @cart_item = @cart.cart_items.find_by(product: params[:id])
    @product = @cart_item.product

    @cart_item.destroy

    flash[:warning] = "成功将商品 #{@product.title} 从购物车中删除"
    redirect_to :back
  end

  def update
    @cart = current_cart
    @cart_item = @cart.cart_items.find_by(product: params[:id])

    if @cart_item.product.quantity >= cart_item_params[:quantity].to_i
      @cart_item.update(cart_item_params)
      flash[:notice] = "成功更新数量"
    else
      flash[:warning] = "商品存货不足以加入购物车"
    end

    redirect_to carts_path
  end

  def add_quantity
		if @cart_item.quantity < @cart_item.product.quantity
			@cart_item.quantity += 1
      @cart_item.product.quantity -=1
			@cart_item.save
      # redirect_to :back
      respond_to do |format|
        format.js   { render :layout => false }
      end
		elsif @cart_item.quantity == @cart_item.product.quantity
			redirect_to carts_path, alert: "库存不足！"
		end
	end

	def remove_quantity
		if @cart_item.quantity > 0
			@cart_item.quantity -= 1
      @cart_item.product.quantity +=1
			@cart_item.save
      # redirect_to :back
			respond_to do |format|
        format.js   { render :layout => false }
      end
		elsif @cart_item.quantity == 0
			redirect_to carts_path, alert: "商品不能少于零！"
		end
	end


  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def find_cart_item
    @cart = current_cart
    @cart_item = @cart.cart_items.find_by(product_id: params[:id])
  end

end
