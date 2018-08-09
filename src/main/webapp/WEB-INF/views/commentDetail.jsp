<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2018/7/25
  Time: 10:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path;
%>
<html>
<head>
    <title>优辅在线销售系统-评价细节</title>
    <link href="<%=basePath%>/static/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/static/css/header.css" rel="stylesheet" type="text/css"/>
    <style rel="stylesheet">
    .answer:hover{
        color:#2d8cf0;
    }

    .ivu-icon-ios-star{
        font-size:20px !important;
    }
</style>

</head>
<body>
<div class="layout" v-cloak id="app">
    <Layout>
        <Header>
            <i-menu mode="horizontal" theme="dark">
                <div class="layout-logo">
                    <a href="/onlineSale/index">
                        <img src="<%=basePath%>/upload/image/logo.png" class="logo-img">
                    </a>
                </div>
                <div class="layout-nav">
                    <template v-if="!haveLogin">
                        <Menu-Item name="login">
                            <a href="/onlineSale/login">
                                <Icon type="ios-navigate"></Icon>
                                登录
                            </a>
                        </Menu-Item>
                        <Menu-Item name="register">
                            <a href="/onlineSale/register">
                                <Icon type="ios-keypad"></Icon>
                                注册
                            </a>
                        </Menu-Item>
                    </template>

                    <Menu-Item name="username" v-else>
                        <a href="/onlineSale/personCenter/">
                            <template>
                                <Avatar id="userPic" :src="'<%=basePath%>'+avatarSrc"/>
                            </template>
                            <span>{{username}}</span>
                        </a>
                    </Menu-Item>

                    <Menu-Item name="MyCart">
                        <Badge :count="cartNum">
                            <a href="/onlineSale/myCart/">
                                <Icon type="ios-cart"></Icon>
                                购物车
                            </a>
                        </Badge>
                    </Menu-Item>
                    <Menu-Item name="MyOrder">
                        <a href="/onlineSale/myOrder/">
                            <Icon type="bag"></Icon>
                            我的订单
                        </a>
                    </Menu-Item>

                    <Menu-Item name="MyOrder" v-if="haveLogin && isSeller">
                        <a href="/onlineSale/myStore/">
                            <Icon type="home"></Icon>
                            我的店铺
                        </a>
                    </Menu-Item>

                    <Menu-Item name="MyMessage" v-if="haveLogin">
                        <Badge :count="messageNum">
                            <a href="/onlineSale/myMessage?content=name1">
                                我的消息
                            </a>
                        </Badge>

                    </Menu-Item>

                    <Menu-Item name="logout" v-if="haveLogin">
                        <a style="color: #cd121b" @click="signOut()">
                            <Icon type="log-out"></Icon>
                            退出
                        </a>
                    </Menu-Item>
                </div>
            </i-menu>
        </Header>

        <Content class="layout-content-center">
            <Row>
                <i-col span="12" offset="6" style="min-height: 650px;">
                    <div style="border-style: solid;border-color: #dddee1;border-width:1px;padding:10px">
                        <Row>
                            <i-col span="3">
                                <Row>
                                    <i-col span="5">
                                        <Avatar id="userPic" :src="'<%=basePath%>'+avatarSrc"/>
                                    </i-col>
                                    <i-col span="6" style="margin-top: 11px">
                                        {{commentFather.user.userName}}
                                    </i-col>
                                </Row>
                            </i-col>
                            <i-col span="21" style="margin-top: 15px">
                                <Row>
                                    <i-col span="2">

                                            <Icon type="ios-star" v-for="n in commentFather.level" :key="n" style="color:#ed3f14">
                                            </Icon>

                                    </i-col>
                                </Row>

                                <Row style="text-align: start;margin-top:40px">
                                    <i-col>
                                        <span style="text-align: start;font-size:12pt">{{commentFather.comment}}</span>
                                    </i-col>
                                </Row>
                                <Row style="margin_top:30px" v-for="t in commentAddList">
                                    <i-col span="24" style="text-align: start;">
                                        <span style="color:#80848f;font-size:8pt">[购买{{countDay(commentFather.commentTime,t.commentTime)}}天后追评]</span>
                                    </i-col>
                                    <i-col span="24" style="text-align: start;">
                                        <span>{{t.comment}}</span>
                                    </i-col>
                                </Row>
                                <Row style="margin-top:20px;margin-bottom: 10px">
                                    <i-col span="4" style="text-align: start;">
                                        <span style="color:#80848f;font-size:8pt">{{commentFather.goods.goodsDescription}}</span>
                                    </i-col>
                                    <i-col span="4"style="text-align: start;">
                                        <span>
                                            {{judgeNow(commentFather.commentTime)}}
                                        </span>
                                    </i-col>
                                    <i-col span="16">

                                    </i-col>
                                </Row>
                                <Row style="margin-top:10px" @keyup.enter="submitAnswer(commentFather,-1)">
                                    <i-col span="24">
                                        <div style="border-style: solid;padding:5px;border-width: 1px;border-color:#dddee1;background-color:  #eeeeee">
                                            <i-form>
                                                <Form-Item>
                                                    <i-input v-model="answerContent" type="textarea" :rows="6"
                                                             :placeholder="'回复 '+commentFather.user.userName">
                                                    </i-input>
                                                </Form-Item>
                                                <Form-Item>
                                                    <i-button type="primary" @click="submitAnswer(commentFather,-1)" style="float: right;margin-top:-17px;margin-bottom: -20px">
                                                        Submit
                                                    </i-button>
                                                </Form-Item>
                                            </i-form>
                                        </div>

                                    </i-col>
                                </Row>

                                <Row v-if="commentList.length==0">
                                    <i-col>
                                        <p>无子评论====</p>
                                     </i-col>
                                </Row>
                                <Row v-else >
                                    <Row v-for="(item,index) in commentList" style="margin-top:5px" @keyup.enter="submitAnswer(item,index)">
                                        <div :style="calCulSpace(item)">
                                            <Row style="text-align: start;">
                                            <span>
                                                {{item.user.userName}}
                                            </span>
                                                <span>:{{item.comment}}</span>
                                            </Row>

                                            <Row style="text-align: start;">
                                            <span style="color:#80848f;font-size:6pt">
                                                {{datetimeFormatFromLong(item.commentTime)}}
                                            </span>
                                            </Row>
                                        </div>

                                        <Row>
                                            <%--<span style="float:right" ></span>--%>

                                                <span style="float:right;margin-top: -18px;" @click="togglePanel(item)" class="answer">回复</span>
                                                <div :id="item.id" style="display: none">
                                                    <Row style="margin-top:10px">
                                                        <div style="border-style: solid;padding:5px;border-width: 1px;border-color:#dddee1;background-color:  #eeeeee">
                                                            <i-form>
                                                                <Form-Item>
                                                                    <i-input v-model="itemAnswerContent.cur[index]"
                                                                             type="textarea"
                                                                             :rows="6"
                                                                             :placeholder="'回复'+item.user.userName">
                                                                    </i-input>
                                                                </Form-Item>
                                                                <Form-Item>
                                                                    <i-button type="primary"
                                                                              @click="submitAnswer(item,index)"
                                                                              style="float: right;margin-top:-17px;margin-bottom: -20px">
                                                                        Submit
                                                                    </i-button>
                                                                </Form-Item>
                                                            </i-form>
                                                        </div>
                                                    </Row>
                                                </div>


                                        </Row>
                                        <hr style="color: #e8eaec">

                                    </Row>
                                </Row>
                            </i-col>

                        </Row>
                    </div>
                </i-col>
            </Row>
        </Content>
        <Footer class="layout-footer-center">
            <hr style="margin-bottom: 10px;"/>
            2014-2018 &copy; software engineering
        </Footer>
    </Layout>
</div>

<script type="text/javascript" src="<%=basePath%>/static/js/jquery-2.0.0.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/vue.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/iview.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/js/common.js"></script>
<%--获取本机ip，存储在returnCitySN对象中--%>
<script src="http://pv.sohu.com/cityjson?ie=utf-8"></script>
<script type="text/javascript">
    var app = new Vue({
        el: "#app",

        data: {
            avatarSrc: "/upload/image/defaultAvatar.jpg",
            username: "",
            userId: "",
            haveLogin: false,
            isSeller: false,
            cartNum: 0,
            messageNum:cookie("messageNum")||0,
            keys: "",

            answerContent: "",
            purchaseNum: 1,
            isSecKill: false,
            num: 0,


            itemAnswerContent:{
                cur:[]
            },
            commentAddList:[],
            commentFather:"",
            commentList:[]
        },

        methods:{
            calCulSpace:function(item){
                return "margin-left:"+(item.arrange-1)*20+"px"
            }
        }


    });


    function togglePanel(item){
        var id="#"+item.id;
        $(id).toggle();
    }
    function judgeNow(time){

        var datetimeType="";
        var now=new Date();
        var date=new Date();
        date.setTime(time);
        if(getMonth(now)==getMonth(date)&&getDay(now)==getDay(date)&&now.getFullYear()==date.getFullYear()){
            datetimeType+= "  " + getHours(date);   //时
            datetimeType+= ":" + getMinutes(date);      //分
            datetimeType+= ":" + getSeconds(date);      //分
        }
        else{
            datetimeType+= date.getFullYear();   //年
            datetimeType+= "-" + getMonth(date); //月
            datetimeType+= "-" + getDay(date);   //日

        }
        return datetimeType;

    }

    //计算追评的天数
    function countDay(firstDay,newDay){
        var first=new Date(firstDay);
        var second=new Date(newDay);
        var days=parseInt(Math.abs(first.getTime()-second.getTime())/86400000);
        return days;
    }



    function submitAnswer(father,index) {
        var id="#"+father.id;
        $(id).hide();
        if(app.haveLogin){
            var item=new Object();
            var user=new Object();
            if(index==-1){
                item.comment="回复"+father.user.userName+":"+app.answerContent;
                app.answerContent="";
                console.log(item.comment);
            }
            else{
                item.comment="回复"+father.user.userName+":"+app.itemAnswerContent.cur[index];
                app.itemAnswerContent.cur[index]="";
                console.log(item.comment);
            }
            user.userName=app.username;
            item.user=user;
            var now=new Date();
            item.arrange=father.arrange+1;
            item.commentTime=now.getTime();
            console.log(item);
            app.commentList=insert(app.commentList,item,index+1);
            console.log(app.commentList);


            var data={
                commentId:father.id,
                arrangeFather:father.arrange,
                commentText:item.comment,
                userId:app.userId
            };
            ajaxPost("/onlineSale/addSonComments",data,function(res){
                if(res.code=="success"){
                }
            },null,false);

        }else{
            var form=document.createElement("form");//定义一个form表单
            form.action = "/onlineSale/myCart/gotoLogin";
            form.method = "post";
            form.style.display = "none";
            var opt = document.createElement("input");
            opt.name = "redirectUrl";
            opt.value = window.location;
            form.appendChild(opt);
            document.body.appendChild(form);//将表单放置在web中
            form.submit();//表单提交
        }

    }
    function refreshSonComments() {
        var data={
            fatherId:"${commentId}"
        };

        ajaxPost("/onlineSale/getSonComment",data,function (res) {
            app.commentList=res.data;
        },null,false);
    }

    $(document).ready(function () {

        ajaxGet("/onlineSale/getLoginUserInfo",function (res) {
            if(res.code==="success")
            {
                app.username=res.data.userName;
                app.userId=res.data.id;
                app.avatarSrc=res.data.userPic;
                app.haveLogin=true;
                if(res.data.userType==="ADMINISTRATOR")
                {
                    app.isSeller=true;
                }

                ajaxGet("/onlineSale/getMessageNum?userId="+app.userId,function(res){
                    app.messageNum=res.data;
                    var option={
                        path:"/onlineSale",
                        expires:7
                    };

                    cookie("messageNum",app.messageNum,option);
                },null,false)

            }
        },null,false);
        ajaxGet("/onlineSale/getCommentsDetail?goodsId="+"${goods.id}"+"&userId="+"${userId}"+"&commentId="+"${commentId}",function(res){

            app.commentAddList=res.data.commentsAddList;
            app.commentFather=res.data.commentFather;
        },null,false);
        refreshSonComments()
    });


    function insert(arr, item, index) {
        return arr.slice(0,index).concat(item, arr.slice(index));
    }
    function signOut(){
        var list={
            idList:cookie("cartGoodsIdList")||"",
            numList:cookie("itemNumList")||""
        };
        ajaxPost("/onlineSale/logout",list,function(res){
            if(res.code=="success"){
                var option={
                    path:"/onlineSale",
                    expires:7,
                };
                cookie("cartGoodsIdList","");
                cookie("itemNumList","");
                cookie("cartGoodsNum",0);
                console.log("goodsDetail进入退出方法");
                window.location.href="/onlineSale/login/";
            }
        },null,false);

    }
</script>
</body>
</html>
