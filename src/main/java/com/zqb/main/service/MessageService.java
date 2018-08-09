package com.zqb.main.service;

import com.zqb.main.dao.MessageDao;
import com.zqb.main.entity.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class MessageService {
    @Autowired
    private MessageDao messageDao;


    public int addMessage(Message message){
        return messageDao.addMessage(message);
    }

    public int getMessageNumByUserId(String userId){
        return messageDao.getMessageNumByUserId(userId);
    }

    public List<Message> getMessagesByUserId(String userId){
        return messageDao.getMessagesByUserId(userId);
    }
    public int deleteById(String id){
        return messageDao.deleteById(id);
    }
    public int updateMessageById(String message,String id){
        return messageDao.updateMessageById(message,id);
    }
}
