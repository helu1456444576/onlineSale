package com.zqb.main.dao;

import com.zqb.main.entity.Message;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by zqb on 2018/4/10.
 */
@Repository
public interface MessageDao {
    int addMessage(Message message);
    int getMessageNumByUserId(String userId);
    int deleteById(String id);
    List<Message> getMessagesByUserId(String userId);
    int updateMessageById(@Param("message") String message,@Param("id") String id);
}
