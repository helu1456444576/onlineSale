<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2018/8/1
  Time: 18:14
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
    <title>个人信息</title>
    <link href="<%=basePath%>/static/bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/static/css/header.css" rel="stylesheet" type="text/css"/>
    <style rel="stylesheet">
        .ivu-tabs-nav{
            height:50px !important;
        }
        .ivu-upload-select{
            height:200px !important;
            width:200px !important;
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
                <i-col span="10" offset="7" style="border:solid;border-color:#e8eaec;border-width:1px;margin-top:20px">

                    <Tabs value="name1">
                        <Tab-Pane label="基本信息" name="name1">
                            <Row>
                                <i-col span="14" offset="5">
                                    <i-form ref="formValidate" :model="formValidate" :rules="ruleValidate" :label-width="60">
                                        <Form-Item label="登录名" prop="name">
                                            <i-input v-model="formValidate.name" placeholder="请输入登录名用于登录"/>
                                        </Form-Item>
                                        <Form-Item label="性别">
                                            <Radio-group v-model="formValidate.sex">
                                                <Radio label="male">男</Radio>
                                                <Radio label="female">女</Radio>
                                                <Radio label="secret">保密</Radio>
                                            </Radio-group>
                                        </Form-Item>
                                        <Form-Item label="生日">
                                            <Date-picker type="date" placeholder="填写你的生日" v-model="formValidate.date"></Date-picker>
                                        </Form-Item>
                                        <Form-Item label="手机号" prop="number">
                                            <i-input v-model="formValidate.number" placeholder="请输入手机号"/>
                                        </Form-Item>
                                        <Form-Item label="邮箱" prop="mail">
                                            <i-input v-model="formValidate.mail" placeholder="请输入你的邮箱"/>
                                        </Form-Item>
                                        <Form-Item>
                                            <i-button type="primary" @click="handleSubmit()">Submit</i-button>
                                            <i-button type="ghost" @click="handleReset()" style="marign-left:8px">Reset</i-button>
                                        </Form-Item>
                                    </i-form>
                                </i-col>
                            </Row>

                        </Tab-Pane>
                        <Tab-Pane label="头像照片" name="name2">
                            <Row>
                                <i-col span="3" offset="3" style="margin-top:40px">
                                    <label style="font-size: 12px;color: #495060">上传头像照片</label>
                                </i-col>
                                <i-col span="12" style="margin-top:50px">
                                    <Upload style="width: 100%"
                                            accept="image/*"
                                            :before-upload="handleBeforeUploadPic"
                                            :show-upload-list="false">
                                        <i-Button type="ghost" style="width: 130%;height: 100%;"><Icon type="ios-plus-empty" size="100"></Icon></i-Button>

                                    </Upload>
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
            cartNum:cookie("cartGoodsNum")|| 0,
            messageNum:cookie("messageNum")||0,
            keys: "",

            photo:{
                src:"",
                file:null
            },

            formValidate:{
                name:"",
                sex:"",
                date:"",
                number:"",
                mail:""
            },

            hasPic:false,

            ruleValidate:{
                name:[
                    {required:true,message:'登录名不能为空',trigger:'blur'}
                ],
                number:[
                    {
                        required:true,
                        trigger:'blur',
                        validator:function(rule,value,callback){
                            if(!/^[a-z0-9]+$/.test(value)){
                                callback('电话号码必须为数字');
                            }
                            else if(value.length!=11){
                                callback('请输入正确格式的电话号码');
                            }
                            else{
                                callback('');
                            }
                        }
                    }
                ],
                mail:[
                    {
                        required:true,
                        trigger:'blur',
                        validator:function(rule,value,callback){
                            if(!/^([0-9a-zA-Z_.-])+@([0-9a-zA-Z_.-])+(\.([a-zA-Z_-])+)+$/.test(value)){
                                callback('请输入正确的邮箱格式');
                            }
                            else{
                                callback('');
                            }
                        }
                    }
                ]
            }
        }
    });

    $(document).ready(function () {

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
                },null,false)
            }
        }, null, false);
    });

    //提交重新填写的信息
    function handleSubmit(){
        var user={
            userName:app.formValidate.name,
            userMobile:app.formValidate.number,
            userMail:app.formValidate.mail
        };
        console.log(user);
        console.log(app.userId);
        ajaxPost("/onlineSale/updateUserMessage?userId="+app.userId,user,function(res){
            if(res.code=="success"){
                alert("提交成功");
            }
        },null,false);
    }
    //此函数放在app内部无作用，原因不明
    function handleBeforeUploadPic(file)
    {
        if (file.size > 10485760) {
            app.$Message.warning("照片大小超过限制");
            return false;
        }
        if (file.type.indexOf("image") != 0) {
            app.$Message.warning("文件类型不支持");
            return false;
        }
        var reader = new FileReader();
        reader.onload = function (e) {
            app.photo.src = e.target.result;
            app.photo.file = file;
        };
        reader.readAsDataURL(file);
        app.hasPic=true;
        return false;
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
