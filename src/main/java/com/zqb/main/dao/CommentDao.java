package com.zqb.main.dao;

import com.zqb.main.entity.Comment;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentDao {
    List<Comment> selectCommentByGoodsId(@Param("goodsId") String goodsId);
    int addComment(Comment comment);
    int  addSonComment(Comment comment);
    List<Comment> getAllComments(Comment comment);
    int getCommentCountByGoodsId(String goodsId);
    Comment selectCommentById(String id);
    List<Comment> selectCommentByGoodsIdAndUserId(@Param("goodsId") String goodsId,@Param("userId") String userId);
    List<Comment> getAddCommentsByGoodsIdAndUserId(@Param("goodsId") String goodsId,@Param("userId") String userId);
    List<Comment> getSonCommentsByFatherId(@Param("fatherId") String fatherId);
    boolean updateFatherSonNum(Comment comment);
    List<Comment> getSellerComment(@Param("fatherId") String fatherId);
    Comment getFatherCommentByGoodsIdAndUserId(@Param("goodsId") String goodsId,@Param("userId") String userId);
}
