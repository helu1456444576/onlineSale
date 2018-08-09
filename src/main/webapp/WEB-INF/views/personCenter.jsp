<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2018/8/1
  Time: 10:03
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
    <title>个人中心</title>
    <link href="<%=basePath%>/static/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/static/css/header.css" rel="stylesheet" type="text/css"/>

    <style rel="stylesheet">
        #homeUserPic{
            width:60px !important;
            height:60px !important;
        }
        .ivu-tabs-nav-wrap{
            height:50px !important;
        }
        .ivu-icon-ios-list-outline{
            font-size:30px !important;
        }
        .ivu-icon-ios-box-outline{
            font-size:30px !important;
        }
        .ivu-icon-ios-chatboxes-outline{
            font-size:30px !important;
        }
        .ivu-icon-ios-gear-outline{
            font-size:30px !important;
        }
        .ivu-tabs-tab{
            margin:10px !important;
        }
        .ivu-tabs-ink-bar{
            display: none !important;
        }

        .add:hover{
            color:#2d8cf0
        }
        .ivu-card{
            background-color: transparent !important;
        }
        .ivu-card-bordered{
            border:none !important;
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
            <Row style="margin-bottom: 10px">
                <i-col span="2" offset="4">
                    <span style="font-size:20pt">个人中心</span>
                </i-col>
                <i-col span="18" style="margin-top: 5px">
                    <Row>
                        <i-col span="2" offset="2">
                            <Dropdown placement="bottom-start">
                                <a href="javascript:void(0)">
                                    <span style="font-size:15pt">首页</span>
                                    <Icon type="ios-arrow-down"></Icon>
                                </a>
                                <DropdownMenu slot="list">
                                    <Dropdown-Item name="1-1"><a href="/onlineSale/myOrder/">订单中心</a></Dropdown-Item>
                                    <Dropdown-Item name="1-2">我的钱包</Dropdown-Item>
                                    <Dropdown-Item name="1-3"><a href="/onlineSale/myFocus/">我的关注</a></Dropdown-Item>
                                </DropdownMenu>
                            </Dropdown>
                        </i-col>
                        <i-col span="2" offset="1">
                            <Dropdown>
                                <a href="javascript:void(0)">
                                    <span style="font-size:15pt">账户设置</span>
                                    <Icon type="ios-arrow-down"></Icon>
                                </a>
                                <DropdownMenu slot="list">
                                    <Dropdown-Item style="font-size:10pt" name="2-1"><a href="/onlineSale/editUserMessage/">个人信息</a></Dropdown-Item>
                                    <Dropdown-Item style="font-size:10pt" name="2-2">收货地址</Dropdown-Item>
                                    <Dropdown-Item style="font-size:10pt" name="2-3">账号绑定</Dropdown-Item>
                                </DropdownMenu>
                            </Dropdown>

                        </i-col>
                    </Row>
                </i-col>

            </Row>
            <hr style="color: #e8eaec">
            <Row>
                <i-col span="2" offset="4">
                    <i-menu active-name="1-2" :open-names="['1']" @on-select="trans">
                        <Submenu name="1">
                            <template slot="title">
                                <span style="font-size:15pt">订单中心</span>
                            </template>
                            <Menu-Item name="1-1" style="margin-top:10px">我的订单</Menu-Item>
                            <Menu-Item name="1-2" style="margin-top:10px">评价晒单</Menu-Item>
                        </Submenu>
                        <Submenu name="2">
                            <template slot="title">
                                <span style="font-size:15pt">我的关注</span>
                            </template>
                            <Menu-Item name="2-1" style="margin-top:10px" >关注商品</Menu-Item>
                            <Menu-Item name="2-2" style="margin-top:10px" >关注店铺</Menu-Item>
                        </Submenu>
                        <Submenu name="3">
                            <template slot="title">
                                <span style="font-size:15pt">账户设置</span>
                            </template>
                            <Menu-Item name="3-1" style="margin-top:10px" >个人信息</Menu-Item>
                            <Menu-Item name="3-2" style="margin-top:10px" >收货地址</Menu-Item>
                            <Menu-Item name="3-3" style="margin-top:10px" >账号绑定</Menu-Item>
                        </Submenu>
                    </i-menu>
                </i-col>
                <i-col span="12" offset="2">
                    <Row style="border:solid;border-color: #e8eaec;border-width:1px;background-color: #F0F0F0;margin-top:20px">
                        <i-col span="2" style="text-align: start;margin: 10px">
                            <template>
                                <Avatar id="homeUserPic" :src="'<%=basePath%>'+avatarSrc"/>
                            </template>
                        </i-col>
                        <i-col span="2" style="text-align: start;margin-top: 22px">
                            <span style="font-size: 15pt">用户名</span>
                        </i-col>
                        <i-col span="6" offset="3" style="margin-top:22px">
                            <Row><span style="color: red;font-size: 12pt" v-bind="money">余额:{{money}}元</span></Row>
                            <Row><a @click="addMoney()"><span class="add">充值</span></a></Row>
                        </i-col>
                    </Row>
                    <Row>
                        <i-col span="15">
                            <Row style="border:solid;border-color:#e8eaec;border-width:1px;margin-top:20px">
                                <Row style="text-align: start">
                                    <span style="font-size: 15pt;margin:10px">我的订单</span>
                                </Row>
                                <hr style="color: #e8eaec">


                                <Row style="margin-top:20px;margin-bottom:20px">
                                    <i-col span="5" offset="2">
                                        <Card>
                                            <Row>
                                                <Icon type="ios-list-outline"></Icon>
                                            </Row>
                                           <Row>

                                               <a href="/onlineSale/myCart/"><span>待付款</span></a>
                                               <%--//跳转至购物车--%>
                                           </Row>

                                        </Card>
                                    </i-col>
                                    <i-col span="5">
                                        <Card>
                                            <Row>
                                                <Icon type="ios-box-outline"></Icon>
                                            </Row>
                                            <Row>
                                                <a href="/onlineSale/myMessage?content=name2"><span>待收货</span></a>
                                                <%--//新建收货页面--%>
                                            </Row>

                                        </Card>
                                    </i-col>
                                    <i-col span="5">
                                        <Card>
                                            <Row>
                                                <Icon type="ios-chatboxes-outline"></Icon>
                                            </Row>
                                            <Row>
                                                <a href="/onlineSale/myMessage?content=name3"><span>待评价</span></a>
                                                <%--//新建评价页面--%>
                                            </Row>

                                        </Card>
                                    </i-col>
                                    <i-col  span="5">
                                        <Card>
                                            <Row>
                                                <Icon type="ios-gear-outline"></Icon>
                                            </Row>
                                            <Row>
                                                <a href="/onlineSale/myMessage?content=name4"><span>退款</span></a>
                                                <%--//新建退款页面--%>
                                            </Row>

                                        </Card>
                                    </i-col>
                                </Row>

                            </Row>

                        </i-col>
                        <i-col span="8" offset="1">
                            <Row style="border:solid;border-color:#e8eaec;border-width:1px;margin-top:20px">
                                <Row style="text-align: start">
                                    <span style="font-size: 15pt;margin:10px">我的关注</span>
                                </Row>
                                <hr style="color: #e8eaec">
                                <Row style="margin-top:20px">
                                    <i-col span="8">
                                        <span style="font-size:10pt">{{focusGoodsNum}}</span>
                                    </i-col>
                                    <i-col span="8">
                                        <span style="font-size:10pt">0</span>
                                    </i-col>
                                    <i-col span="8">
                                        <span style="font-size:10pt">0</span>
                                    </i-col>
                                </Row>
                                <Row style="margin-top:10px;margin-bottom: 20px">
                                    <i-col span="8">
                                        <a  href="/onlineSale/myFocus/"><span style="font-size:10pt">商品关注</span></a>
                                    </i-col>
                                    <i-col span="8">
                                        <a><span style="font-size:10pt">店铺关注</span></a>
                                    </i-col>
                                    <i-col span="8">
                                        <a><span style="font-size:10pt">收藏内容</span></a>
                                    </i-col>
                                </Row>
                            </Row>
                        </i-col>
                    </Row>

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

            avatarSrc:"/upload/image/defaultAvatar.jpg",
            username:"",
            userId:"c1409d9c3b794b91867144e2aba05304",
            haveLogin:false,
            isSeller:false,
            cartNum:cookie("cartGoodsNum")||0,
            messageNum:cookie("messageNum")||0,
            focusGoodsNum:0,

            keys:"",

            moneyAdd:0,
            money:0

        },
        methods:{
            trans:function(name){
                console.log(name);
                if(name=='1-1'){
                    window.location.href="/onlineSale/myOrder/"
                }else if(name=='1-2'){
                    //跳转到评论页面
                }else if(name=='2-1'){
                    window.location.href="/onlineSale/myFocus?content=name1"
                }else if(name=='2-2'){
                    window.location.href="/onlineSale/myFocus?content=name2"
                }else if(name=='3-1'){
                    window.location.href="/onlineSale/editUserMessage?userId="+app.userId
                }
            }
        }

    });

    $(document).ready(function () {
        ajaxGet("/onlineSale/getLoginUserInfo",function (res) {
            if(res.code=="success")
            {
                app.username=res.data.userName;
                app.userId=res.data.id;
                app.avatarSrc=res.data.userPic;
                app.haveLogin=true;

                if(res.data.userType==="ADMINISTRATOR")
                {
                    app.isSeller=true;
                }
                ajaxGet("/onlineSale/getMoney?userId="+app.userId,function(res){
                    if(res.code=="success"){
                        app.money=res.data.money;
                    }
                },null,false);

                ajaxGet("/onlineSale/getMessageNum?userId="+app.userId,function(res){
                    app.messageNum=res.data;
                    var option={
                        path:"/onlineSale",
                        expires:7
                    };

                    cookie("messageNum",app.messageNum,option);
                },null,false)
                ajaxGet("/onlineSale/getFocusGoodsNum?userId="+app.userId,function (res) {
                  if(res.code=="success"){
                      app.focusGoodsNum=res.data;
                  }
                },null,false)
            }
        },null,false);

    });

    function addMoney(){

        var detail="<div style='margin-top: -12px;'><h4>充值详情</h4></div>";
        detail+="<span>充值金额</span>";
        detail+="<input  id='inputAdd'/>";
        detail+="</div>";


        app.$Modal.info({
            content: detail,
            width:800,
            top:300,
            loading: true,
            onOk: function () {

                var test=Number($('#inputAdd').val());
                app.moneyAdd=test;
                app.money+=app.moneyAdd;
                app.$Modal.remove();

                var data={
                    moneyAdd:app.moneyAdd
                };

                ajaxPost("/onlineSale/addMoney?userId="+app.userId,data,function(res){
                    if(res.code=="success"){
                        alert("充值成功");
                    }
                },null,false);
            }
        });

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
