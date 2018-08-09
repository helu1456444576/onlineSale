package com.zqb.main.controller;

import com.zqb.main.dto.AjaxMessage;
import com.zqb.main.dto.CommentNode;
import com.zqb.main.dto.MsgType;
import com.zqb.main.dto.Page;
import com.zqb.main.entity.*;
import com.zqb.main.service.*;
import com.zqb.main.utils.CheckSQLStrUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.logging.SimpleFormatter;

@Controller
@RequestMapping(value = "/onlineSale")
public class GoodsController {
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

    @Autowired
    private CartService cartService;
//
//    @RequestMapping(value = {"/index","/"})
//    public String welcome(Model model, HttpSession session)
//    {
//        return "myOrder";
//    }

    @RequestMapping(value="/addCollection")
    @ResponseBody
    public Object addCollection(@RequestParam("goodsId") String goodsId,
                                @RequestParam("userId") String userId){

        GoodsCollection goodsCollection=new GoodsCollection();
        Goods goods=goodsService.getGoodsByPrimaryKey(goodsId);
        User user=userService.getByPrimaryKey(userId);
        goodsCollection.setGoods(goods);
        goodsCollection.setUser(user);
        goodsCollection.preInsert();
        goodsCollectionService.addGoodsCollection(goodsCollection);
        return new AjaxMessage().Set(MsgType.Success,"评论提交成功",goodsCollection);
    }

    @RequestMapping(value="/reduceCollection")
    @ResponseBody
    public Object reduceCollection(@RequestParam("goodsId") String goodsId,
                                   @RequestParam("userId") String userId){

        Goods goods=goodsService.getGoodsByPrimaryKey(goodsId);
        User user=userService.getByPrimaryKey(userId);
        GoodsCollection goodsCollection=new GoodsCollection();
        goodsCollection.setUser(user);
        goodsCollection.setGoods(goods);
        if(goodsCollectionService.deleteGoodsCollection(goodsCollection)>=0){
            return new AjaxMessage().Set(MsgType.Success,"取消收藏成功",goodsCollection);
        }
        return new AjaxMessage().Set(MsgType.Error,"取消收藏失败",goodsCollection);
    }

    @RequestMapping(value="/requireGoodsCollection")
    @ResponseBody
    public Object requireGoodsCollection(@RequestParam("goodsId") String goodsId,
                                         @RequestParam("userId") String userId){
        GoodsCollection goodsCollection=goodsCollectionService.requireByUserIdAndGoodsId(userId,goodsId);
        if(goodsCollection!=null){
            return new AjaxMessage().Set(MsgType.Success,"收藏",goodsCollection);
        }
        return new AjaxMessage().Set(MsgType.Error,"没收藏",goodsCollection);
    }
    @RequestMapping(value="/myComment")
    public String myComment(Model model,HttpServletRequest request){
        String goodsId=request.getParameter("goodsId");
        model.addAttribute("goodId",goodsId);
        return "myComment";
    }


    @RequestMapping("/commentDetail")
    public String commentDetail(HttpServletRequest request,Model model){
        String goodsId=request.getParameter("goodsId");
        String userId=request.getParameter("userId");
        String commentId=request.getParameter("commentId");
        model.addAttribute("goodsId",goodsId);
        model.addAttribute("userId",userId);
        model.addAttribute("commentId",commentId);
        return "commentDetail";
    }

    @RequestMapping(value="/getCommentsDetail",method=RequestMethod.GET)
    @ResponseBody
    public Object getCommentsDetail(@RequestParam("commentId") String commentId){
        Comment comment=commentService.selectCommentById(commentId);
        List<Comment> commentsAdd=commentService.getAddCommentsByGoodsIdAndUserId(comment.getGoods().getId(),comment.getUser().getId());
        HashMap<String,Object> map= new HashMap<String,Object>();
        map.put("commentFather",comment);
        map.put("commentsAddList",commentsAdd);
        if(comment!=null){
            return new AjaxMessage().Set(MsgType.Success,map);
        }
        return null;
    }
    @RequestMapping(value="/addToCart",method=RequestMethod.POST)
    @ResponseBody
    public Object addToCart(HttpServletRequest request,HttpSession session){

        return cartService.addToCart(request,session);
    }

    @RequestMapping(value="/getCartNum",method = RequestMethod.GET)
    @ResponseBody
    public Object getCartNum(@RequestParam("userId") String userId){
        Integer count=cartService.getCartNumByUserId(userId);
        if(count>=0){
            return new AjaxMessage().Set(MsgType.Success,count);
        }
        return new AjaxMessage().Set(MsgType.Error,null);
    }

    @RequestMapping(value="/addSonComments",method=RequestMethod.POST)
    @ResponseBody
    public Object addSonComments(HttpServletRequest request){
        String commentId=request.getParameter("commentId");
        String commentText=request.getParameter("commentText");
        String userId=request.getParameter("userId");
        String arrange=request.getParameter("arrangeFather");
        User user=userService.getByPrimaryKey(userId);
        Comment father=commentService.selectCommentById(commentId);
        int haveChildren=father.getHaveChildren();
        father.setHaveChildren(haveChildren+1);
        commentService.updateFatherSonNum(father);
        Date commentTime=new Date();
        Comment commentSon=new Comment();
        commentSon.setFatherId(commentId);
        commentSon.setComment(commentText);
        commentSon.setCommentTime(commentTime);
        if(user.getUserType().equals(0)){
            commentSon.setFirstTime(2);
        }
        else{
            commentSon.setFirstTime(3);
        }
        commentSon.setUser(user);
        commentSon.preInsert();
        commentSon.setArrange(Integer.parseInt(arrange)+1);
        if(commentService.addSonComment(commentSon)>0){
            return new AjaxMessage().Set(MsgType.Success,"评论提交成功",commentSon);
        }
        return new AjaxMessage().Set(MsgType.Error,"提交评论失败",null);

    }

    @RequestMapping(value="/getSonComment",method=RequestMethod.POST)
    @ResponseBody
    public Object getSonComment(HttpServletRequest request){

        String fatherId=request.getParameter("fatherId");

        List<Comment> commentSon=commentService.getSonCommentsByFatherId(fatherId);


        Comment  father=commentService.selectCommentById(fatherId);
        List<CommentNode> tree=new ArrayList<CommentNode>();
        CommentNode  fatherNode=new CommentNode();
        fatherNode.setComment(father);
        fatherNode.setRemain(father.getHaveChildren());
        fatherNode.setSonStart(1);
        tree.add(fatherNode);
        int start=1+father.getHaveChildren();
        int index=0;
        while(true){
            index=judgeFirst(index,tree);
            if(index==-1) break;
            else{

                List<Comment> son=commentService.getSonCommentsByFatherId(tree.get(index).getComment().getId());
                List<CommentNode> sonNodes=new ArrayList<CommentNode>();
                for(Comment comment:son){
                    CommentNode sonNode=new CommentNode();
                    sonNode.setComment(comment);
                    sonNode.setRemain(comment.getHaveChildren());
                    sonNode.setSonStart(start);
                    start+=comment.getHaveChildren();
                    sonNodes.add(sonNode);
                }
                tree.addAll(sonNodes);
                index++;
            }
        }

        List<CommentNode> sonNodes1=new ArrayList<CommentNode>();
        sonNodes1.add(fatherNode);


        while(true){
            int i=judge(sonNodes1);
            if(i==-1) break;
            else{
                CommentNode commentNode=sonNodes1.get(i);
                int begin=commentNode.getSonStart();
                int remain=commentNode.getRemain();
                sonNodes1.add(tree.get(begin));
                begin=begin+1;
                remain=remain-1;
                commentNode.setRemain(remain);
                commentNode.setSonStart(begin);
                sonNodes1.set(i,commentNode);

            }
        }

        List<Comment> commentList=new ArrayList<Comment>();

        for(int i=1;i<sonNodes1.size();i++){
            commentList.add(sonNodes1.get(i).getComment());
        }



        return new AjaxMessage().Set(MsgType.Success,commentList);
    }

    private int  judge(List<CommentNode> sonNodes1) {
        for(int i=sonNodes1.size()-1;i>=0;i--){
            CommentNode now =sonNodes1.get(i);
            if(now.getRemain()>0){
                return i;
            }
        }
        return -1;
    }

    private int judgeFirst(int index,List<CommentNode> tree){
        for(int i=index;i<tree.size();i++){
            if(tree.get(i).getRemain()>0) return i;
        }
        return -1;
    }


    @RequestMapping(value="/getComments",method = RequestMethod.GET)
    @ResponseBody
    public Object getComments(@RequestParam("goodsId") String goodsId,
                                @RequestParam("pageNo") int pageNo,
                              @RequestParam("keys") String keys){
        if(keys!=null&&!keys.equals("")){
            if(CheckSQLStrUtils.sql_inj(keys)){
                return new AjaxMessage().Set(MsgType.Error,"请勿输入非法字符！",null);
            }
        }
        Page<Comment> page=new Page<Comment>(pageNo,4);
        //page.setFuncName("changePage");
        Comment comment=new Comment();
        comment.setPage(page);
        Goods goods=goodsService.getGoodsByPrimaryKey(goodsId);
        if(goods!=null){
            comment.setGoods(goods);
            List<Comment> comments=commentService.getAllComments(comment);
            int length=comments.size();
            List<HashMap<String,Object>> sum=new ArrayList<HashMap<String, Object>>();
            for(int i=0;i<length;i++){
                User user=comments.get(i).getUser();
                List<Comment> commentsAdd=commentService.getAddCommentsByGoodsIdAndUserId(goodsId,user.getId());
                List<Comment> commentSellerList=commentService.getSellerComment(comments.get(i).getId());
                for(Comment c: commentSellerList){
                    System.out.println(c.getUser().getUserType().getId()+"-----"+c.getComment());
                }
                HashMap<String,Object> mapAdd=new HashMap<String, Object>();
                mapAdd.put("commentFirst",comments.get(i));
                mapAdd.put("commentAddList",commentsAdd);
                mapAdd.put("commentSellerList",commentSellerList);
                sum.add(mapAdd);
            }
            page.initialize();
            HashMap<String,Object> map=new HashMap<String, Object>();
            map.put("list",sum);
            map.put("total",commentService.getCommentCountByGoodsId(goodsId));
//            System.out.println(comments.size()+"comments.size()");
//            System.out.println(commentService.getCommentCountByGoodsId(goodsId)+"commentService.getCommentCountByGoodsId(goodsId)");
            return new AjaxMessage().Set(MsgType.Success,map);

        }
        return null;
    }

    @RequestMapping(value="/submitComment",method = RequestMethod.POST)
    @ResponseBody
    public Object submitComment(HttpServletRequest request){
        String goodsId=request.getParameter("goodsId");
        String username=request.getParameter("username");
        User user=userService.getUserByName(username);
        Date commentTime=new Date();
        int  commentLevel=Integer.parseInt(request.getParameter("commentLevel"));
        String commentText=request.getParameter("commentText");
        Goods goods=goodsService.getGoodsByPrimaryKey(goodsId);
        List<Comment> comments=commentService.selectCommentByGoodsIdAndUserId(goodsId,user.getId());
        int firstTime=0;
        if(comments.size()==0){
            firstTime=1;
        }
        Comment comment=new Comment();
        comment.setUser(user);
        comment.setGoods(goods);
        comment.setCommentTime(commentTime);
        comment.setLevel(commentLevel);
        comment.setComment(commentText);
        comment.setFirstTime(firstTime);
        //        把数据保存到数据库
        comment.preInsert();
        if(commentService.addComment(comment)>0){
            return new AjaxMessage().Set(MsgType.Success,"评论提交成功",null);
        }
        else{
            return new AjaxMessage().Set(MsgType.Error,"提交评论失败",null);
        }
    }



}
