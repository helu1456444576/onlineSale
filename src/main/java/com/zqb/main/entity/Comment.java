package com.zqb.main.entity;

import java.util.Date;

/**
 * Created by zqb on 2018/4/10.
 */
public class Comment extends BasicEntity<Comment>{

    private Goods goods;

    private String fatherId;

    private User user;

    private String comment;

    private Date commentTime;

    public int getHaveChildren() {
        return haveChildren;
    }

    public void setHaveChildren(int haveChildren) {
        this.haveChildren = haveChildren;
    }

    private int  haveChildren;

    private int level;

    public int getArrange() {
        return arrange;
    }

    public void setArrange(int arrange) {
        this.arrange = arrange;
    }

    private int arrange;

    public int getFirstTime() {
        return firstTime;
    }

    public void setFirstTime(int firstTime) {
        this.firstTime = firstTime;
    }

    private int firstTime;

    public Comment(){

    }

    public Goods getGoods() {
        return goods;
    }

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    public String getFatherId() {
        return fatherId;
    }

    public void setFatherId(String fatherId) {
        this.fatherId = fatherId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(Date commentTime) {
        this.commentTime = commentTime;
    }



    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    @Override
    public String toString() {
        return "{" +
                "goods:" + goods +
                ", fatherId:'" + fatherId + '\'' +
                ", user:" + user +
                ", comment:'" + comment + '\'' +
                ", commentTime:" + commentTime +
                ", haveChildren:" + haveChildren +
                ", level:" + level +
                ", arrange:" + arrange +
                ", firstTime:" + firstTime +
                '}';
    }
}
