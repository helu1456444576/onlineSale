package com.zqb.main.service;

import com.zqb.main.dao.CommentDao;
import com.zqb.main.dao.GoodsDao;
import com.zqb.main.entity.Comment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class CommentService {
    @Autowired
    private GoodsDao goodsDao;
    @Autowired
    private CommentDao commentDao;

   public List<Comment> selectCommentByGoodsId(String goodsId){
       return commentDao.selectCommentByGoodsId(goodsId);
   }
    public int addComment(Comment comment){
       return commentDao.addComment(comment);
    }
    public int  addSonComment(Comment comment){
        return commentDao.addSonComment(comment);
    }

    public List<Comment> getAllComments(Comment comment){
        return commentDao.getAllComments(comment);
    }

    public int getCommentCountByGoodsId(String goodsId){
        return commentDao.getCommentCountByGoodsId(goodsId);
    }

    public Comment selectCommentById(String id){
        return commentDao.selectCommentById(id);
    }

    public List<Comment> selectCommentByGoodsIdAndUserId(String goodsId,String userId){
        return commentDao.selectCommentByGoodsIdAndUserId(goodsId,userId);
    }

    public List<Comment> getAddCommentsByGoodsIdAndUserId(String goodsId,String userId){
        return commentDao.getAddCommentsByGoodsIdAndUserId(goodsId,userId);
    }
    public List<Comment> getSonCommentsByFatherId(String fatherId){
        return commentDao.getSonCommentsByFatherId(fatherId);
    }

    public boolean updateFatherSonNum(Comment comment){
        return commentDao.updateFatherSonNum(comment);
    }

    public List<Comment> getSellerComment(String fatherId){
        return commentDao.getSellerComment(fatherId);
    }

    public Comment getFatherCommentByGoodsIdAndUserId(String goodsId,String userId){
        return commentDao.getFatherCommentByGoodsIdAndUserId(goodsId,userId);
    }
}
