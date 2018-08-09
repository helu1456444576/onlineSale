package com.zqb.main.controller;

import com.zqb.main.dto.AjaxMessage;
import com.zqb.main.dto.MsgType;
import com.zqb.main.entity.Cart;
import com.zqb.main.entity.Goods;
import com.zqb.main.entity.User;
import com.zqb.main.service.CartService;
import com.zqb.main.service.GoodsService;
import com.zqb.main.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

    /**
     * Created by zqb on 2018/4/16.
     */

    @Controller
    @RequestMapping(value = "/onlineSale")
    public class CartController {

        @Autowired
        private CartService cartService;
        @Autowired
        private UserService userService;
        @Autowired
        private GoodsService goodsService;

        @RequestMapping(value = "/myCart")
        public String welcome(Model model, HttpSession session) {
            return "myCart";
        }


        @RequestMapping(value = "/getCart", method = RequestMethod.GET)
        @ResponseBody
        public Object getCart(@RequestParam("userId") String userId) {

            List<Cart> cartList = cartService.getCartGoodsByUserId(userId);
            if (cartList != null) {
                return new AjaxMessage().Set(MsgType.Success, cartList);
            }
            return new AjaxMessage().Set(MsgType.Error, cartList);
        }


        @RequestMapping(value = "/myCart/gotoLogin", method = RequestMethod.POST)
        public String gotoLogin(HttpServletRequest request, HttpSession session) {
            String path = request.getParameter("redirectUrl");
            session.setAttribute("redirectUrl", path);//把url放到session
            return "login";
        }

        @RequestMapping(value = "/updateGoodsNum", method = RequestMethod.POST)
        @ResponseBody
        public Object updateGoodsNum(HttpServletRequest request) {
            String id = request.getParameter("id");
            int num = Integer.parseInt(request.getParameter("changeNum"));
            if (cartService.updateGoodsNumById(num, id) >= 0) {
                return new AjaxMessage().Set(MsgType.Success, num);
            }
            return new AjaxMessage().Set(MsgType.Error, num);
        }

        @RequestMapping(value = "/deleteCartGoods", method = RequestMethod.POST)
        @ResponseBody
        public Object deleteCartGoods(@RequestParam("id") String id) {
            if (cartService.deleteCartGoodsById(id) >= 0) {
                return new AjaxMessage().Set(MsgType.Success, null);
            }
            return new AjaxMessage().Set(MsgType.Error, null);
        }

        @RequestMapping(value = "/getCartGoods", method = RequestMethod.GET)
        @ResponseBody
        public Object getCartGoods(HttpServletRequest request) {
            return new AjaxMessage().Set(MsgType.Success, cartService.getGoodsByIdList(request));
        }

        @RequestMapping(value = "/updateCartList")
        @ResponseBody
        public Object updateCartList(HttpServletRequest request, HttpSession session) {
            User user = (User) session.getAttribute("userSession");
            String cartGoodsId = request.getParameter("idList");
            String itemNum = request.getParameter("numList");
            String[] cartGoodsArray = cartGoodsId.split(";");
            String[] itemNumArray = itemNum.split(";");

            if(cartGoodsId!=""){
                for (int i = 0; i < cartGoodsArray.length; i++) {
                    if(cartGoodsArray[i]!=""&&itemNumArray[i]!=""){
                        System.out.println(cartGoodsArray[i]);
                        System.out.println(itemNumArray[i]);
                        Cart c1 = cartService.getCartByGoodsId(cartGoodsArray[i], user.getId());
                        int num = Integer.parseInt(itemNumArray[i]);
                        if (c1 == null){
                            Goods goods = goodsService.getGoodsByPrimaryKey(cartGoodsArray[i]);
                            Cart cart = new Cart();
                            cart.setUser(user);
                            cart.setGoods(goods);
                            cart.setGoodsCount(num);
                            cart.preInsert();
                            cartService.add(cart);
                        }else{
                            int count=c1.getGoodsCount();
                            c1.setGoodsCount(count+num);
                            cartService.updateGoodsNumById(count+num,c1.getId());
                        }
                    }
                }
            }

            List<Cart> userCartList = cartService.getCartGoodsByUserId(user.getId());
            String cartGoodsList = "";
            String itemNumList = "";
            for (Cart cart : userCartList) {
                cartGoodsList += cart.getGoods().getId() + ";";
                itemNumList += cart.getGoodsCount() + ";";
            }
            int cartGoodsNum = userCartList.size();
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("cartGoodsList", cartGoodsList);
            map.put("itemNumList", itemNumList);
            map.put("cartGoodsNum", cartGoodsNum);

            return new AjaxMessage().Set(MsgType.Success, "加入购物车成功", map);

        }
    }