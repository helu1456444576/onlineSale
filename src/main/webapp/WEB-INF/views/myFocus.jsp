<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2018/8/2
  Time: 11:42
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
    <title>我的关注</title>
    <link href="<%=basePath%>/static/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/static/css/header.css" rel="stylesheet" type="text/css"/>
    <style rel="stylesheet">
        .ivu-tabs-nav{
            height:50px !important;
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
                <i-col span="14" offset="5" style="border:solid;border-color:#e8eaec;border-width:1px;margin-top:20px">
                    <Tabs :value=name>
                        <Tab-Pane label="我关注的商品" name="name1">
                            <Row v-for="(item,index) in focusGoodsList" style="margin-bottom: 20px">
                                <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                    <Row>
                                        <i-col span="5">
                                            <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                                <img :src="'<%=basePath%>'+item.goods.goodsPic" style="width: 100px;"/>
                                            </div>
                                        </i-col>
                                        <i-col span="8">
                                            <div  style="margin-top:30px">
                                                <span>{{item.goods.goodsName}}{{item.goods.goodsDescription}}</span>
                                            </div>
                                        </i-col>
                                        <i-col span="5">
                                            <div style="margin-top:40px">
                                                <span>价格：{{item.goods.goodsPrice}}</span>
                                            </div>

                                        </i-col>
                                        <i-col span="6">
                                            <div style="margin-top:40px">
                                                <i-button @click="cancelFocus(item,index)">取消收藏</i-button>
                                            </div>

                                        </i-col>
                                    </Row>
                                </i-col>
                            </Row>
                        </Tab-Pane>
                        <Tab-Pane label="我关注的店铺" name="name2">

                        </Tab-Pane>
                    </Tabs>
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
            cartNum: cookie("cartGoodsNum")||0,
            messageNum:cookie("messageNum")||0,
            keys: "",
            name:"",

            focusGoodsList:[]
        }
    });

    $(document).ready(function () {
        app.name='${name}';
        if(app.name==""){
            app.name=="name1";
        }
        console.log(app.name);

        ajaxGet("/onlineSale/getLoginUserInfo", function (res) {
            if (res.code === "success") {
                app.username = res.data.userName;
                app.userId = res.data.id;
                app.avatarSrc = res.data.userPic;
                app.haveLogin = true;
                ajaxGet("/onlineSale/getFocusGoods?userId="+app.userId,function (res) {
                    app.focusGoodsList=res.data;
                },null,false);
                if (res.data.userType === "ADMINISTRATOR") {
                    app.isSeller = true;
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
        }, null, false);
    });

    function cancelFocus(item,index){

        app.focusGoodsList.splice(index,1);

        ajaxGet("/onlineSale/reduceCollection?goodsId="+item.goods.id+"&userId="+app.userId,function(res){

        },null,false);
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
</body>
</html>
