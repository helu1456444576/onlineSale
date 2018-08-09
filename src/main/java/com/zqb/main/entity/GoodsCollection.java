package com.zqb.main.entity;

public class GoodsCollection  extends BasicEntity<GoodsCollection>{
    public Goods getGoods() {
        return goods;
    }

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    private Goods goods;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "GoodsCollection{" +
                "goods=" + goods +
                ", user=" + user +
                '}';
    }

    private User user;

}
