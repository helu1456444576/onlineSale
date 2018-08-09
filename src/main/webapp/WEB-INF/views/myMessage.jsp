<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2018/8/5
  Time: 11:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path;
    String commentDetail="/onlineSale/commentDetail?goodsId=";
%>
<html>
<head>
    <title>我的消息</title>
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
    </Layout>
    <Content class="layout-content-center">
        <Row>
            <i-col span="14" offset="5" style="border:solid;border-color:#e8eaec;border-width:1px;margin-top:20px">
                <Tabs :value=name>
                    <Tab-Pane :label="label1" name="name1" v-if="!isSeller">
                        <Row v-for="(item,index) in waitDeliverMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="cancelTrade(item,index,'待发货')">取消交易</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label5" name="name5" v-if="isSeller">
                        <Row v-for="(item,index) in waitDeliverMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="sellerDeliver(item,index)">发货</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label2" name="name2" v-if="!isSeller">
                        <Row v-for="(item,index) in waitCollectMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="confirmTrade(item,index)">确认收货</i-button>
                                            <i-button @click="cancelTrade(item,index,'待收货')">取消交易</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label6" name="name6" v-if="isSeller">
                        <Row v-for="(item,index) in evaluateMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="sellerRespond(item,index)">回复评论</i-button>
                                        </div>

                                    </i-col>

                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label3" name="name3" v-if="!isSeller">
                        <Row v-for="(item,index) in waitEvaluateMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="gotoComment(item,index)">评论</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label7" name="name7" v-if="isSeller">
                        <Row v-for="(item,index) in waitRefundMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="sellerRefund(item,index)">退款</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label9" name="name9" v-if="isSeller">
                        <Row v-for="(item,index) in collectMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="confirmCollect(item,index)">确认</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>

                    </Tab-Pane>
                    <Tab-Pane :label="label4" name="name4" v-if="!isSeller">
                        <Row v-for="(item,index) in waitRefundMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:50px">
                                            <span style="color:red">退款中</span>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>
                    <Tab-Pane :label="label8" name="name8" v-if="!isSeller">
                        <Row v-for="(item,index) in refundMessageList" style="margin-bottom: 20px">
                            <i-col span="20" offset="2" style="border:solid;border-color: #e8eaec;border-width:1px" >
                                <Row style="border:solid;border-color: #e8eaec;border-width:1px">
                                    <div style="text-align: start;margin-left: 10px" >{{datetimeFormatFromLong(item.time)}}</div>
                                </Row>
                                <Row>
                                    <i-col span="4">
                                        <div style="border:solid;border-color: #e8eaec;border-width:1px;margin:10px">
                                            <img :src="'<%=basePath%>'+item.goodsPIC" style="width: 100px;"/>
                                        </div>
                                    </i-col>
                                    <i-col span="8">
                                        <div  style="margin-top:50px">
                                            <span>{{item.goodsName}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="2">
                                        <div style="margin-top:50px">
                                            <span>×{{item.num}}</span>
                                        </div>
                                    </i-col>
                                    <i-col span="4">
                                        <div style="margin-top:50px">
                                            <span>金额：{{item.Price}}</span>
                                        </div>

                                    </i-col>
                                    <i-col span="6">
                                        <div style="margin-top:40px">
                                            <i-button @click="confirmRefund(item,index)">确认</i-button>
                                        </div>

                                    </i-col>
                                </Row>
                            </i-col>
                        </Row>
                    </Tab-Pane>

                </Tabs>
            </i-col>
        </Row>
    </Content>

    <Footer class="layout-footer-center">
        <hr style="margin-bottom: 10px;"/>
        2014-2018 &copy; software engineering
    </Footer>
</div>

<script type="text/javascript" src="<%=basePath%>/static/js/jquery-2.0.0.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/vue.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/iview.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/js/common.js"></script>
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
            name:"name1",

            waitDeliverMessageList:[], //待发货消息列表
            waitCollectMessageList:[],//待收货消息列表
            waitEvaluateMessageList:[],//待评价消息列表
            waitRefundMessageList:[],//待退款消息列表
            refundMessageList:[],//已退款消息列表
            collectMessageList:[],//已收货消息列表
            evaluateMessageList:[],//已评论消息列表

            waitDeliverMessageNum:0,//待发货消息数量
            waitCollectMessageNum:0,//待收货消息数量
            waitEvaluateMessageNum:0,//待评价消息数量
            waitRefundMessageNum:0,//待退款消息数量
            refundMessageNum:0, //已退款消息数量
            collectMessageNum:0,//已收货消息数量
            evaluateMessageNum:0,//已评论消息数量

            label1: function(h)  {
                return h('div', [
                    h('span', '待发货'),
                    h('Badge', {
                        props: {
                            count:app.waitDeliverMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;",
                        },
                    })
                 ])
            },

            label2: function(h)  {
                return h('div', [
                    h('span', '待收货'),
                    h('Badge', {
                        props: {
                            count:app.waitCollectMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;",
                        },
                    })
                ])
            },

            label3: function(h)  {
                return h('div', [
                    h('span', '待评价'),
                    h('Badge', {
                        props: {
                            count:app.waitEvaluateMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;",
                        },
                    })
                ])
            },

            label4: function(h)  {
                return h('div', [
                    h('span', '待退款'),
                    h('Badge', {
                        props: {
                            count:app.waitRefundMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;",
                        },
                    })
                ])
            },

            label5: function(h)  {
                return h('div', [
                    h('span', '发货'),
                    h('Badge', {
                        props: {
                            count:app.waitDeliverMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;",
                        },
                    })
                ])
            },

            label6: function(h)  {
                return h('div', [
                    h('span', '查看评论'),
                    h('Badge', {
                        props: {
                            count:app. evaluateMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;",
                        },
                    })
                ])
            },

            label7: function(h)  {
                return h('div', [
                    h('span', '退款'),
                    h('Badge', {
                        props: {
                            count:app.waitRefundMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;"
                        },
                    })
                ])
            },

            label8: function(h)  {
                return h('div', [
                    h('span', '已退款'),
                    h('Badge', {
                        props: {
                            count:app.refundMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;"
                        },
                    })
                ])
            },

            label9: function(h)  {
                return h('div', [
                    h('span', '已收货'),
                    h('Badge', {
                        props: {
                            count:app.collectMessageNum
                        },
                        attrs:{
                            style:"float:right;margin-top:-8px;margin-left:5px;"
                        },
                    })
                ])
            }
        }


    });
    $(document).ready(function () {
        console.log("进入方法");
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
                if (res.data.userType === "ADMINISTRATOR") {
                    app.isSeller = true;
                }

                ajaxGet("/onlineSale/getMessageNum?userId="+app.userId,function(res){
                    app.messageNum=res.data;
                    var option={
                        path:"/onlineSale",
                        expires:7
                    };
                    cookie("messageNum",app.messageNum,option);
                },null,false);

                ajaxGet("/onlineSale/getMessages?userId="+app.userId,function(res){
                    if(res.code=="success"){
                        res.data.forEach(function (item) {
                            var val=$.parseJSON(item.message);
                            eval("val."+"buyer"+"='"+item.buyer.id+"'");
                            eval("val."+"seller"+"='"+item.seller.id+"'");
                            eval("val."+"id"+"='"+item.id+"'");
                            console.log(item);
                            console.log(val);
                            if(val.content=="待发货"){
                                app.waitDeliverMessageList.push(val);
                                app.waitDeliverMessageNum++;
                            }else if(val.content=="待收货"){
                                app.waitCollectMessageList.push(val);
                                app.waitCollectMessageNum++;
                            }else if(val.content =="已收货"){
                                app.waitEvaluateMessageList.push(val);
                                app.waitEvaluateMessageNum++;
                            }else if(val.content=="待退款"){
                                app.waitRefundMessageList.push(val);
                                app.waitRefundMessageNum++;
                            }else if(val.content=="已退款"){
                                app.refundMessageList.push(val);
                                app.refundMessageNum++;
                            }else if(val.content=="已收货"){
                                app.collectMessageList.push(val);
                                app.collectMessageNum++;
                            }else if(val.content=="已评论"){
                                app.evaluateMessageList.push(val);
                                app.evaluateMessageNum++;
                            }
                        })
                    }
                })
            }
        }, null, false);
    });

    //买家在待发货时取消交易在待受收货时取消交易
    function cancelTrade(item,index,code){
        //给卖家发送退款消息
        var now =new Date();

        var message={
            content:"待退款",
            goodsName:item.goodsName,
            Price:item.Price,
            goodsPIC:item.goodsPIC,
            num:item.num,
            time:now.getTime(),
            goodsId:item.goodsId
        };

        var m=JSON.stringify(message);
        //数据库更新该条消息的message将其中的content从待发货或者待收货改成该退款
        var data={
            id:item.id,
            message:m
        }

        ajaxPost("/onlineSale/updateTradeMessage",data,function(res){
            if(res.code=="success"){
                //在自己的收货和发货列表里去除该条消息，并且更新他们的数量
                if(code=="待发货"){
                    app.waitDeliverMessageList.splice(index,1);
                    app.waitDeliverMessageNum--;
                }else{
                    app.waitCollectMessageList.splice(index,1);
                    app.waitCollectMessageNum--;
                }
                //在自己的待退款消息里更新添加该条消息，并且更新数量
                eval("message."+"buyer"+"='"+item.buyer.id+"'");
                eval("message."+"seller"+"='"+item.seller.id+"'");
                eval("message."+"id"+"='"+item.id+"'");
                app.waitRefundMessageList=insert(app.waitRefundMessageList,item,0);
                app.waitRefundMessageNum++;
            }
        },null,false)

    }

    //确认收货
    function confirmTrade(item,index){
        //更新该条消息将其改为已收货
        var now =new Date();

        var message={
            content:"已收货",
            goodsName:item.goodsName,
            Price:item.Price,
            goodsPIC:item.goodsPIC,
            num:item.num,
            time:now.getTime(),
            goodsId:item.goodsId
        };
        var m=JSON.stringify(message);

        var data={
            id:item.id,
            message:m
        };

        ajaxPost("/onlineSale/updateTradeMessage",data,function(res){
            if(res.code=="success"){
                app.waitCollectMessageList.splice(index,1);
                app.waitCollectMessageNum--;
                app.messageNum--;
            }
        },null,false);
    }

    //买家去评论
    function gotoComment(item,index){
        //更新该条消息将其改为已评论
        var now =new Date();

        var message={
            content:"已评论",
            goodsName:item.goodsName,
            Price:item.Price,
            goodsPIC:item.goodsPIC,
            num:item.num,
            time:now.getTime(),
            goodsId:item.goodsId
        };
        var m=JSON.stringify(message);

        var data={
            id:item.id,
            message:m
        };
        ajaxPost("/onlineSale/updateTradeMessage",data,function (res) {
            if(res.code=="success"){
                app.waitEvaluateMessageList.splice(index,1);
                app.waitEvaluateMessageNum--;
                app.messageNum--;
            }
        },null,false);
        //跳转到评论页面
        window.location.href="/onlineSale/myComment?goodsId="+item.goodsId;
    }


    //卖家发货
    function sellerDeliver(item,index){
        //改变消息状态为待收货
        var now =new Date();

        var message={
            content:"待收货",
            goodsName:item.goodsName,
            Price:item.Price,
            goodsPIC:item.goodsPIC,
            num:item.num,
            time:now.getTime(),
            goodsId:item.goodsId
        };
        var m=JSON.stringify(message);
        var data={
            id:item.id,
            message:m
        };
        ajaxPost("/onlineSale/updateTradeMessage",data,function(res){
            if(res.code=="success"){
                //将该条消息从卖家的待发货消息中去除
                app.waitDeliverMessageList.splice(index,1);
                app.waitDeliverMessageNum--;
                app.messageNum--;
            }
        },null,false);

    }

    //卖家回复评论
    function sellerRespond(item,index) {
        //获取goodsId buyerId commentId
        //跳转到commentDetail页面
        var goodsId=item.goodsId;
        var userId=item.buyer;


        var data={
           goodsId:item.goodsId,
            userId:item.buyer
        };
        console.log("未进入方法");


        //获取commentId
        ajaxPost("/onlineSale/getFatherCommentId",data,function (res) {
            if(res.code=="success"){
                console.log("进入方法");
                var commentId=res.data.id;
                console.log(goodsId);
                console.log(userId);
                console.log(commentId);
                window.location.href='<%=commentDetail%>'+goodsId+'&userId='+userId+'&commentId='+commentId;
            }
        },null,false);

    }

    //卖家退款
    function sellerRefund(item,index) {
        //将消息更新为已退款
        var now =new Date();

        var message={
            content:"已退款",
            goodsName:item.goodsName,
            Price:item.Price,
            goodsPIC:item.goodsPIC,
            num:item.num,
            time:now.getTime(),
            goodsId:item.goodsId
        };
        var m=JSON.stringify(message);
        var data={
            id:item.id,
            message:m
        };

        ajaxPost("/onlineSale/updateTradeMessage",data,function(res){
            if(res.code=="success"){
                //将消息从卖家消息那里删除
                app.waitRefundMessageList.splice(index,1);
                app.waitRefundMessageNum--;
                app.messageNum--;
            }
        },null,false);

    }
    //卖家确认收货
    function confirmCollect(item,index){
        //删除该消息在数据库和本地都删除
        var data={
            id:item.id
        }
        ajaxPost("/onlineSale/deleteTradeMessage",data,function(res){
            if(res.code=="success"){
                //在本地删除
                app.collectMessageList.splice(index,1);
                app.collectMessageNum--;
                //消息总数量减少一个
                app.messageNum--;
            }
        },null,false)
    }

    //买家确认已退款
    function confirmRefund(item,index){
        //删除该消息在数据库和本地
        var data={
            id:item.id
        };
        ajaxPost("/onlineSale/deleteTradeMessage",data,function(res){
            if(res.code=="success"){
                //在本地删除
                app.refundMessageList.splice(index,1);
                app.refundMessageList--;
                //消息总数量减少一个
                app.messageNum--;
            }
        })

    }
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
                    expires:7
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
