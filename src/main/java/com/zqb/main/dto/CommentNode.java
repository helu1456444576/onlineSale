package com.zqb.main.dto;

import com.zqb.main.entity.Comment;

public class CommentNode {
    public Comment getComment() {
        return comment;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }

    private Comment comment;

    public int getSonStart() {
        return sonStart;
    }

    public void setSonStart(int sonStart) {
        this.sonStart = sonStart;
    }

    private int sonStart;

    public int getRemain() {
        return remain;
    }

    public void setRemain(int remain) {
        this.remain = remain;
    }

    private int remain;

    @Override
    public String toString() {
        return "CommentNode{" +
                "comment=" + comment +
                '}';
    }
}
