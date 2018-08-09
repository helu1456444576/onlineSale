package com.zqb.main.controller;

import com.alibaba.fastjson.JSONObject;
import com.zqb.main.dto.AjaxMessage;
import com.zqb.main.dto.MsgType;
import com.zqb.main.entity.*;
import com.zqb.main.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/onlineSale")
public class MessageController {
    @Autowired
    private MessageService messageService;
    @Autowired
    private UserService userService;

    @Autowired
    private CartService cartService;

    @Autowired
    private GoodsService goodsService;
    @Autowired
    private CommentService commentService;

    @RequestMapping(value="/myMessage")
    public String getMyMessage(@RequestParam("content")String name,Model model){

        model.addAttribute("name",name);
        System.out.println(name+"name的值");
        return "myMessage";
    }

    @RequestMapping(value="/addMessage")
    @ResponseBody
    public Object addMessage(HttpServletRequest request){
        String buyerId=request.getParameter("buyer");
        String sellerId=request.getParameter("seller");
        String goodsId=request.getParameter("goodsId");
        int num=Integer.parseInt(request.getParameter("num"));
        String content=request.getParameter("content");
        Date now=new Date();
        Goods goods=goodsService.getGoodsByPrimaryKey(goodsId);
        //构造json对象转换为字符串赋值给message属性
        JSONObject obj=new JSONObject();
        obj.put("num",num);
        obj.put("Price",goods.getGoodsPrice()*num);
        obj.put("goodsPIC",goods.getGoodsPic());
        obj.put("goodsName",goods.getGoodsName());
        obj.put("content",content);
        obj.put("time",now);
        obj.put("goodsId",goodsId);
        //新建Message类
        Message message=new Message();
        message.setBuyer(userService.getByPrimaryKey(buyerId));
        message.setSeller(userService.getByPrimaryKey(sellerId));
        message.setMessage(obj.toString());
        message.preInsert();
        if(messageService.addMessage(message)>=0){
            return new AjaxMessage().Set(MsgType.Success,null);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/updateTradeMessage")
    @ResponseBody
    public Object updateTradeMessage(HttpServletRequest request){
        String id=request.getParameter("id");
        String message=request.getParameter("message");
        if(messageService.updateMessageById(message,id)>=0){
            return new AjaxMessage().Set(MsgType.Success,null);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/deleteTradeMessage")
    @ResponseBody
    public Object deleteTradeMessage(HttpServletRequest request){
        String id=request.getParameter("id");
        if(messageService.deleteById(id)>=0){
            return new AjaxMessage().Set(MsgType.Success,null);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/getMessageNum",method=RequestMethod.GET)
    @ResponseBody
    public Object getMessageNum(@RequestParam("userId") String userId){
        int messageNum=messageService.getMessageNumByUserId(userId);
        if(messageNum>=0){
            return new AjaxMessage().Set(MsgType.Success,messageNum);
        }
        return  new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/getMessages")
    @ResponseBody
    public Object getMessages(@RequestParam("userId") String userId){
        List<Message> messageList=messageService.getMessagesByUserId(userId);
        if(messageList!=null){
            return new AjaxMessage().Set(MsgType.Success,messageList);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/getFatherCommentId")
    @ResponseBody
    public Object getFatherCommentId(HttpServletRequest request){
        String goodsId=request.getParameter("goodsId");
        String userId=request.getParameter("userId");
        Comment comment=commentService.getFatherCommentByGoodsIdAndUserId(goodsId,userId);
        if(comment!=null){
            return new AjaxMessage().Set(MsgType.Success,comment);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }
}
