package com.zqb.main.entity;

public class CartGoods  extends BasicEntity<GoodsCollection>{
    private int count;
    private Goods goods;
    private User user;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getCount() {
        return count;
    }

    public Goods getGoods() {
        return goods;
    }

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    public void setCount(int count) {
        this.count = count;
    }

    @Override
    public String toString() {
        return "CartGoods{" +
                "count=" + count +
                ", goods=" + goods +
                ", user=" + user +
                '}';
    }
}
