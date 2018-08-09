<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2018/7/23
  Time: 9:43
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
    <title>优铺在线销售系统-评论</title>
    <link href="<%=basePath%>/static/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/static/css/header.css" rel="stylesheet" type="text/css"/>

</head>
<body onkeydown="keySubmit()">
<div class="layout" v-cloak id="app">
    <layout>
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
                <i-col span="16" offset="8">
                    <Row>
                        <i-col span="1" style="font-size:20px">评分:</i-col>
                        <i-col span="3">
                            <Rate v-model="levelValue"></Rate>
                        </i-col>
                    </Row>
                    <Row>
                        <i-col span="1" style="font-size:20px">详细:</i-col>
                        <i-col span="10">
                            <i-form>
                                <Form-Item >
                                    <i-input v-model="commentValue" type="textarea"  :autosize="{minRows:1,maxRows:7}" placeholder="输入评论">

                                    </i-input>
                                </Form-Item>

                                <Form-Item>
                                    <i-button type="primary" @click="submitComment()">Submit</i-button>
                                    <i-button type="ghost" style="margin-left:8px" @click="cancelComment()">Cancel</i-button>
                                </Form-Item>
                            </i-form>

                        </i-col>
                    </Row>
                </i-col>
            </Row>
        </Content>
        <jsp:include page="footer.jsp"/>
    </layout>
</div>

</body>

<script type="text/javascript" src="<%=basePath%>/static/js/jquery-2.0.0.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/vue.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/iview.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/js/common.js"></script>
<script type="text/javascript">
    var app=new Vue({
        el:"#app",
        data:{

            avatarSrc:"/upload/image/defaultAvatar.jpg",
            username:"",
            userId:"",
            haveLogin:false,
            isSeller:false,
            cartNum:cookie("cartGoodsNum")||0,
            messageNum:cookie("messageNum")||0,

            levelValue:cookie("levelNum")||0,
            commentValue:cookie("commentText")||""

        }

    });
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
                        expires:7,
                    };

                    cookie("messageNum",app.messageNum,option);
                },null,false)
            }
        },null,false);
    });
    function keySubmit() {
        if (event.keyCode==13)  //回车键的键值为13
        {
            submitComment();
        }

    }

    function submitComment(){
        if(app.commentValue==null){
            alert("请输入你的评论再提交");
        }
        else{
            var option={
                path:"/onlineSale",
                expires:7
            };
            cookie("commentText",app.commentValue,option);
            cookie("levelNum",app.levelValue,option);
            var data={
                goodsId:'${goodId}',
                username:app.username,
                commentLevel:app.levelValue,
                commentText:app.commentValue
            }
            ajaxPost("/onlineSale/submitComment",data,function(res){
                if(res.code=="success"){
                    //评论成功,跳转至订单页面
                    window.location.href="/onlineSale/myOrder/";
                }
            },null,false);

        }
    }

    function cancelComment() {
        //返回到我的订单的页面
        window.location.href="/onlineSale/myOrder/";
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
                cookie("cartGoodsIdList","",option);
                cookie("itemNumList","",option);
                cookie("cartGoodsNum",0,option);
                console.log("goodsDetail进入退出方法");
                window.location.href="/onlineSale/login/";
            }
        },null,false);

    }
</script>
</html>
