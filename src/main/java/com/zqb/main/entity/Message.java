package com.zqb.main.entity;

import java.util.Date;

/**
 * Created by zqb on 2018/4/10.
 */
public class Message extends BasicEntity<Message> {
    private User buyer;

    private User seller;

    private String message;//为kafkaMsg.toString()，是一个json对象

    @Override
    public String toString() {
        return "Message{" +
                "buyer=" + buyer +
                ", seller=" + seller +
                ", message='" + message + '\'' +
                '}';
    }

    public User getBuyer() {
        return buyer;
    }



    public User getSeller() {
        return seller;
    }

    public void setSeller(User seller) {
        this.seller = seller;
    }

    public void setBuyer(User buyer) {

        this.buyer = buyer;
    }


    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }


}
