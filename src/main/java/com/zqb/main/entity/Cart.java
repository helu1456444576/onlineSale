package com.zqb.main.entity;

/**
 * Created by zqb on 2018/4/24.
 */
public class Cart extends BasicEntity<Cart> {

    private Goods goods;

    private User user;

    private int goodsCount;

    public int getGoodsCount() {
        return goodsCount;
    }

    public void setGoodsCount(int goodsCount) {
        this.goodsCount = goodsCount;
    }

    @Override
    public String toString() {
        return "Cart{" +
                "goods=" + goods +
                ", user=" + user +
                ", goodsCount=" + goodsCount +
                '}';
    }

    public Goods getGoods() {
        return goods;
    }

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }



}
