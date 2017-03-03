class ProductsController < ApplicationController

  def index
   @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    # @photos = @product.photos.all
    # @prints = @product.prints.all
    # if @product.huangjin?
    #   render 'products/huangjin'
    # elsif @product.shoushi?
    #   render 'products/shoushi'
    # elsif @product.zhuanshi?
    #   render 'product/zhuanshi'
    # end
  end

  def add_to_cart
    @product = Product.find(params[:id])

    if !current_cart.products.include?(@product)
      current_cart.add_product_to_cart(@product)
      flash[:notice] = "您已经将 #{@product.title} 成功加入购物车"
    else
      flash[:warning] = "你的购物车里已有此商品"
    end

    redirect_to :back
  end



end
