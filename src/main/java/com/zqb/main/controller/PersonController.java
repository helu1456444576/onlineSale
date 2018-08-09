package com.zqb.main.controller;

import com.zqb.main.dto.AjaxMessage;
import com.zqb.main.dto.MsgType;
import com.zqb.main.entity.GoodsCollection;
import com.zqb.main.entity.User;
import com.zqb.main.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping(value = "/onlineSale")
public class PersonController {
    @Autowired
    private UserService userService;

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private OrderService orderService;
    @Autowired
    private GoodsCollectionService goodsCollectionService;

    @RequestMapping(value="/personCenter")
    public String getPersonCenter(HttpServletRequest request){
        return "personCenter";
    }

    @RequestMapping(value="/editUserMessage")
    public String getEditUserMessage(HttpServletRequest request){
        return "editUserMessage";
    }

    @RequestMapping(value="/myFocus")
    public String getMyFocus( @RequestParam("content") String name, HttpServletRequest request,Model model){
        model.addAttribute("name",name);
        return "myFocus";
    }

    @RequestMapping(value="/getFocusGoods")
    @ResponseBody
    public Object getFocusGoods(@RequestParam("userId") String userId){
        List<GoodsCollection> collections=goodsCollectionService.getCollectionGoodsByUserId(userId);
        return new AjaxMessage().Set(MsgType.Success,"成功",collections);
    }

    @RequestMapping(value="/addMoney")
    @ResponseBody
    public Object addMoney(@RequestParam("userId") String userId,HttpServletRequest request){
        String m=request.getParameter("moneyAdd");
        int moneyAdd=Integer.parseInt(m);
        User user=userService.getByPrimaryKey(userId);
        int money=user.getMoney();
        money+=moneyAdd;
        user.setMoney(money);
        if(userService.updateMoneyById(user)>=0){
            return new AjaxMessage().Set(MsgType.Success,"充值成功",user);
        }
        return new AjaxMessage().Set(MsgType.Error,"充值失败",user);
    }
    @RequestMapping(value = "/getMoney")
    @ResponseBody
    public Object getMoney(@RequestParam("userId") String userId){
        User user=userService.getByPrimaryKey(userId);
        return new AjaxMessage().Set(MsgType.Success,"获取成功",user);
    }

    @RequestMapping(value="/reduceMoney")
    @ResponseBody
    public Object reduceMoney(@RequestParam("userId") String userId,HttpServletRequest request){
        String money=request.getParameter("money");
        int m=Integer.parseInt(money);
        User user=userService.getByPrimaryKey(userId);
        user.setMoney(m);
        if(userService.updateMoneyById(user)>=0){
            return new AjaxMessage().Set(MsgType.Success,null);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/getFocusGoodsNum")
    @ResponseBody
    public Object getFocusGoodsNum(@RequestParam("userId") String userId){
        int num=goodsCollectionService.getFocusGoodsNumByUserId(userId);
        if(num>=0){
            return  new AjaxMessage().Set(MsgType.Success,num);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }


}
