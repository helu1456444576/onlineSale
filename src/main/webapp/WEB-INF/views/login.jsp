<%--
  Created by IntelliJ IDEA.
  User: zqb
  Date: 2018/4/3
  Time: 17:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path ;
%>
<html>
<head>
    <title>优铺在线销售系统-登录</title>
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <style>
        body
        {
            background-image: url("/upload/image/login_bg.jpg") ;
            background-repeat: no-repeat;
            background-position: center;
            background-size: cover;
            margin: 0 auto;
            position: relative;
        }
        .login-content
        {
            width: 380px;
            position: absolute;
            top:245px;
            right: 200px;
        }
        .ivu-form-item
        {
            margin-bottom: 34px;
        }
        .ivu-input
        {
            height: 38px;
            font-size: 16px;
        }
        .ivu-input-group
        {
            font-size: 16px;
        }
        .ivu-input-group-append, .ivu-input-group-prepend
        {
            padding: 5px 10px;
        }
        .login-footer
        {
            width: 100%;
            height: 20px;
            line-height: 20px;
            text-align: center;
        }
    </style>

</head>
<body onkeydown="keyLogin()">
    <div id="app">
        <div class="login-content">
            <Card style="padding: 8px 10px;">
                <p slot="title" style="font-size: 18px;">
                    <Icon type="log-in"></Icon> 登录
                    <a style="float: right;" href="/onlineSale/index">前往主页</a>
                </p>
                <i-form id="form" ref="form" :model="userInfo" :rules="validate" style="margin-top: 20px;">
                    <Form-Item prop="userName">
                        <i-input type="text" v-model="userInfo.userName" placeholder="userName" name="userName">
                            <Icon type="ios-person" slot="prepend" size="18"></Icon>
                        </i-input>
                    </Form-Item>

                    <Form-Item prop="userPassword">
                        <i-input type="password" v-model="userInfo.userPassword" placeholder="Password" name="userPassword">
                            <Icon type="ios-locked" slot="prepend"></Icon>
                        </i-input>
                    </Form-Item>

                    <Form-Item>
                        <i-button type="primary" @click="handleSubmit()" long style="font-size: 17px;">登录</i-button>
                    </Form-Item>
                </i-form>

                <div class="login-footer">
                    <p slot="footer">暂无账号？<a href="/onlineSale/register">立即注册</a></p>
                </div>

            </Card>
        </div>

    </div>
</body>
<script type="text/javascript" src="<%=basePath%>/static/js/jquery-2.0.0.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/vue.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/iview/iview.min.js"></script>
<script type="text/javascript" src="<%=basePath%>/static/js/common.js"></script>
<script type="text/javascript">
    //# sourceURL=login.js
    var app = new Vue({
        el: "#app",

        data: {
            userInfo:{
                userName:"",
                userPassword:""
            },
            validate: {
                userName: [
                    { required: true, message: '用户名不能为空', trigger: 'blur' }
                ],
                userPassword: [
                    { required: true, message: '密码不能为空', trigger: 'blur' },
                    { type: 'string', min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
                ]
            }
        }
    });


    function keyLogin() {
        if (event.keyCode==13)  //回车键的键值为13
        {
            handleSubmit();
        }

    }

    function handleSubmit()
    {
        app.$refs['form'].validate( function (valid) {
            if (valid)
            {
                ajaxPost("/onlineSale/doLogin",app.userInfo,function (res) {
                    if(res.code==="success")
                    {
                        //登录成功后将购物车cookie的值更新到数据库

//                        console.log("进入修改cookie的方法");
//                        var option={
//                            path:"/onlineSale",
//                            expires:7,
//                        };
//                        cookie("cartGoodsIdList","",option);
//                        console.log(cookie("cartGoodsIdList"));
//                        cookie("itemNumList","",option);
//                        console.log(cookie("itemNumList"));
//                        cookie("cartGoodsNum",0,option);
//                        console.log(cookie("cartGoodsNum"));
                        var list={
                            idList:cookie("cartGoodsIdList")||"",
                            numList:cookie("itemNumList")||""
                        };

                        ajaxPost("/onlineSale/updateCartList",list,function(t){
                            if(t.code=="success"){
                                //将包括数量在内的三个cookie的值更新
                                var option={
                                  path:"/onlineSale",
                                    expires:7
                                   };
                                cookie("cartGoodsIdList",t.data.cartGoodsList,option);
                                console.log(t.data.cartGoodsList);
                                cookie("itemNumList",t.data.itemNumList,option);
                                console.log(t.data.itemNumList);
                                cookie("cartGoodsNum",t.data.cartGoodsNum,option);
                                console.log(t.data.cartGoodsNum);
                                if(res.data==null)
                                    window.location.href="/onlineSale/index";
                                else
                                    window.location.href=res.data;

                            }
                        },null,false);


                    }
                },null,false);

            }
            else
            {
                app.$Message.error('请正确填写信息!');
            }
        })
    }
</script>
</html>
