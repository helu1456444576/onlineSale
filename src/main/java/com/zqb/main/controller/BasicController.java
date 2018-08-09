package com.zqb.main.controller;

import com.zqb.main.dto.AjaxMessage;
import com.zqb.main.dto.MsgType;
import com.zqb.main.entity.Cart;
import com.zqb.main.entity.Goods;
import com.zqb.main.entity.User;
import com.zqb.main.entity.UserType;
import com.zqb.main.service.CartService;
import com.zqb.main.service.GoodsService;
import com.zqb.main.service.UserService;
import com.zqb.main.utils.Encryption;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by zqb on 2018/4/3.
 */

@Controller
@RequestMapping(value = "/onlineSale")
public class BasicController {

    @Autowired
    private UserService userService;
    @Autowired
    private CartService cartService;
    @Autowired
    private GoodsService goodsService;


    @RequestMapping(value = {"/index",""})
    public String welcome(Model model,HttpSession session)
    {
        return "index";
    }


    @RequestMapping(value = "/login")
    public String login(HttpSession session,HttpServletRequest request)
    {
        if(session.getAttribute("userSession")!=null)//防止重新登录
            return "redirect:index";
        return "login";
    }


    @RequestMapping(value = "/register")
    public String register()
    {
        return "register";
    }


    @RequestMapping(value = "/doLogin",method = RequestMethod.POST)
    @ResponseBody
    public Object doLogin(User user, Model model, HttpSession session)
    {
        User user1=userService.getUserByNameAndPwd(user.getUserName(),user.getUserPassword());
        if(user1!=null)
        {
            session.setAttribute("userSession",user1);
            String url = (String) session.getAttribute("redirectUrl");
            if(url!=null&&url.length()>0)
            {
                return new AjaxMessage().Set(MsgType.Success,"登录成功",url);
            }
            return new AjaxMessage().Set(MsgType.Success,"登录成功",null);
        }
        return new AjaxMessage().Set(MsgType.Error,"用户名或密码错误",null);
    }


    @RequestMapping(value = "/doRegister",method = RequestMethod.POST)
    @ResponseBody
    public Object doRegister(HttpServletRequest request, Model model)
    {
        String userName=request.getParameter("userName");
        if(userService.getUserByName(userName)==null)//检查用户名是否已存在
        {
            User user=new User();
            user.setUserName(userName);
            if(request.getParameter("userType").equals(UserType.USER.getId()+""))
            {
                user.setUserType(UserType.USER);
            }
            else
            {
                user.setUserType(UserType.ADMINISTRATOR);
            }
            user.setUserPassword(Encryption.entryptPasswordMD5(request.getParameter("userPassword")));
            user.setUserPic("/upload/image/defaultAvatar.jpg");
            user.preInsert();
            if(userService.addUser(user)>0)
                return new AjaxMessage().Set(MsgType.Success,"注册成功，自动跳转至登录页",null);
            else
                return new AjaxMessage().Set(MsgType.Error,"注册失败",null);
        }
        else
        {
            return new AjaxMessage().Set(MsgType.Error,"该用户名已被注册！",null);
        }
    }

    @RequestMapping(value = "/getLoginUserInfo",method = RequestMethod.GET)
    @ResponseBody
    public Object getLoginUserInfo(HttpSession session)
    {
        if(session.getAttribute("userSession")!=null)
            return new AjaxMessage().Set(MsgType.Success,null,session.getAttribute("userSession"));
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value = "/logout")
    @ResponseBody
    public Object logout(HttpSession session,HttpServletRequest request)
    {
        User user = (User) session.getAttribute("userSession");
        String cartGoodsId = request.getParameter("idList");
        String itemNum = request.getParameter("numList");
        String[] cartGoodsArray = cartGoodsId.split(";");
        String[] itemNumArray = itemNum.split(";");
        if(cartGoodsArray.length>=1){
            //删除用户购物车中的所有值

            cartService.deleteCartGoodsByUserId(user.getId());
            //重新生成用户的购物车
            for (int i = 0; i < cartGoodsArray.length; i++) {
                if (cartGoodsArray[i]!=""&&itemNumArray[i]!="") {
                    int num = Integer.parseInt(itemNumArray[i]);
                    Goods goods = goodsService.getGoodsByPrimaryKey(cartGoodsArray[i]);
                    if(goods!=null){
                        Cart cart = new Cart();
                        cart.setUser(user);
                        cart.setGoods(goods);
                        cart.setGoodsCount(num);
                        cart.preInsert();
                        cartService.add(cart);
                    }
                }

            }
        }

        session.removeAttribute("userSession");
        session.removeAttribute("redirectUrl");//把url清理

        //把两个cookie的值同步到后台数据库


        return new AjaxMessage().Set(MsgType.Success,null);
    }

    //重新编辑用户信息

    @RequestMapping(value="/updateUserMessage")
    @ResponseBody
    public Object updateUserMessage(@RequestParam("userId") String userId, HttpServletRequest request){
        String userName=request.getParameter("userName");
        String userNumber=request.getParameter("userMobile");
        String userMail=request.getParameter("userMail");
        User user=userService.getByPrimaryKey(userId);

        user.setUserName(userName);
        user.setUserMobile(userNumber);
        user.setUserMail(userMail);

        if(userService.updateUserMessageById(user)>=0){
            return new AjaxMessage().Set(MsgType.Success,null);
        }
        else
            return new AjaxMessage().Set(MsgType.Error,null);
    }
}
