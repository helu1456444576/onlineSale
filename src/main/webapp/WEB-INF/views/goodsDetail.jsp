<%--
  Created by IntelliJ IDEA.
  User: zqb
  Date: 2018/4/23
  Time: 17:00
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
    <title>优铺在线销售系统-商品详情</title>
    <link href="<%=basePath%>/static/iview/styles/iview.css" rel="stylesheet" type="text/css"/>
    <link href="<%=basePath%>/static/css/header.css" rel="stylesheet" type="text/css"/>
    <style rel="stylesheet">
        .ivu-input-number-input,ivu-input-number-handler-wrap
        {
            height: 45px;
        }
        .ivu-input-number-handler
        {
            height: 22px;
        }
        .ivu-input-number-handler-down-inner, .ivu-input-number-handler-up-inner
        {
            line-height: 22px;
            font-size: 16px;
        }

        .demo-spin-icon-load{
            animation: ani-demo-spin 1s linear infinite;
        }

        .ivu-icon-chatbubble-working{
            font-size:15px;
        }
        .ivu-icon-ios-heart-outline{
            font-size:20px !important;
        }
        .ivu-icon-ios-heart{
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
                <i-col span="16" offset="4" style="min-height: 650px;">
                    <Row v-if="!isSecKill">
                        <i-col span="8">
                            <img src="<%=basePath%>${goods.goodsPic}" style="width: 100%;cursor:pointer;"/>
                        </i-col>
                        <i-col span="15" offset="1" style="text-align: left;">
                            <Row style="padding: 5px 15px;margin-top: 12px;">
                                <h1>${goods.goodsName}</h1>
                            </Row>
                            <Row style="background-color: #eeeeee;padding: 10px 15px;">
                                <h2 style="color: red;">￥${goods.goodsPrice}</h2>
                                <p style="font-size: 16px;">${goods.goodsDescription}</p>
                                <p style="font-size: 16px;">商品余量 ：${goods.goodsNum}</p>
                            </Row>

                            <hr style="margin-top: 20px;border-bottom: dotted; border-bottom-color: #b2b2b2;border-bottom-width: thin;"/>
                            <Row style="text-align: center;font-size: 16px;line-height: 22px;margin-top: 10px;">
                                <i-col span="7">
                                    <label>月销量 </label><span style="color: red;font-weight: bolder;"> 123</span>
                                </i-col>

                                <i-col span="1" style="color: #b2b2b2">|</i-col>

                                <i-col span="7">
                                    <label>累计销量 </label><span style="color: red;font-weight: bolder;"> 1234</span>
                                </i-col>

                                <i-col span="1" style="color: #b2b2b2;">|</i-col>

                                <i-col span="7">
                                    <label>累计评价 </label><span style="color: red;font-weight: bolder;" >{{commentCount}}</span>
                                </i-col>
                            </Row>
                            <hr style="margin-top: 10px;border-bottom: dotted; border-bottom-color: #b2b2b2;border-bottom-width: thin;"/>

                            <Row style="margin-top: 20px;">
                                <i-col span="5">
                                    <Input-Number :max="${goods.goodsNum}" :min="1" v-model="purchaseNum" style="height: 45px;"></Input-Number>
                                </i-col>

                                <i-col span="5" offset="1">
                                    <i-button type="error" style="height: 45px;width: 100%;" @click="addToCart">加入购物车</i-button>
                                </i-col>

                                <i-col span="2" offset="11" style="margin-top:15px">
                                    <div  v-if="isCollected">
                                        <a  @click="reduceCollection"><Icon type="ios-heart" style="color: red"></Icon></a>
                                    </div>
                                    <div v-else>
                                        <a @click="addCollection"  ><Icon type="ios-heart-outline"></Icon></a>
                                    </div>

                                </i-col>
                            </Row>
                            <Row style="margin-top:20px;background-color: #eeeeee;height:30px;">

                                <i-col span="6" >
                                    <span  style="margin-left: 15px;vertical-align: middle;font-size:13pt;font-weight:500">全部评论</span>
                                </i-col>
                            </Row>
                            <Row v-if="commentList.length==0">
                                <p>无评论</p>
                            </Row>
                            <Row v-else>
                                <Row  v-for="item in commentList" style="margin-top:5px;margin-bottom: 20px">
                                    <i-col span="3">
                                        <Row style="margin-top: 11px">
                                            <i-col span="5" offset="1">

                                                <Avatar id="userPic" :src="'<%=basePath%>'+avatarSrc"/>

                                            </i-col>
                                            <i-col span="6" offset="3" style="margin-top: 11px">
                                                <span style="color:#80848f;font-size:8pt">{{item.commentFirst.user.userName}}</span>
                                            </i-col>
                                        </Row>
                                    </i-col>
                                    <i-col span="21">
                                        <Row style="margin-top: 11px">
                                            <i-col span="2" style="margin-top: 8px;text-align: start">
                                                <span style="text-align: start">
                                                <Icon type="ios-star" v-for="n in item.commentFirst.level" :key="n"
                                                    style="color:#ed3f14"></Icon>
                                                </span>
                                            </i-col>
                                        </Row>

                                        <Row style="margin-top:15px">
                                            <i-col span="24">
                                                <p style="font-size:10pt">{{item.commentFirst.comment}}</p>
                                            </i-col>
                                        </Row>

                                        <Row style="margin-top:10px;margin-bottom: 10px">
                                            <i-col span="4" style="text-align: start">
                                                <span style="color:#80848f;font-size:8pt">{{item.commentFirst.goods.goodsDescription}}</span>
                                            </i-col>
                                            <i-col span="3">
                                            <span style="text-align: start">
                                                {{judgeNow(item.commentFirst.commentTime)}}
                                            </span>
                                            </i-col>
                                            <i-col span="2"  offset="15" style="margin-top:2px">
                                                <a :href="'<%=commentDetail%>'+item.commentFirst.goods.id+'&userId='+item.commentFirst.user.id+'&commentId='+item.commentFirst.id" target="_blank">
                                                    <Icon type="chatbubble-working" color="grey"></Icon>
                                                </a>
                                            </i-col>
                                        </Row>

                                        <Row v-if="item.commentAddList.length!=0">
                                            <hr style="color:#80848f;opacity: 0.1"/>
                                        </Row>
                                        <Row style="margin-top:10px" v-for="t in item.commentAddList" >

                                            <span style="color:#80848f;font-size:8pt">[购买{{countDay(item.commentFirst.commentTime,t.commentTime)}}天后追评]</span>
                                            <span style="font-size:10pt">{{t.comment}}</span>
                                        </Row>

                                        <Row v-if="item.commentSellerList.length!=0">
                                            <hr style="color:#80848f;opacity: 0.1;margin-top:10px"/>
                                        </Row>
                                        <Row v-for="i in item.commentSellerList" style="margin-top:10px">
                                            <span style="color:red;font-size:10pt">{{i.user.userName}} {{i.comment}} </span>
                                        </Row>
                                    </i-col>

                                    <hr style="color:#80848f;opacity: 0.3"/>
                                </Row>
                                <Row style="margin-top:30px;">
                                    <i-col offset="18" span="5">
                                        <Page :current="page.no" :total="page.total" :page-size='4'  @on-change="changePage($event)" simple>
                                        </Page>
                                    </i-col>

                                </Row>
                            </Row>



                        </i-col>
                    </Row>

                    <Row v-else>
                        <i-col span="8">
                            <img src="<%=basePath%>${secKillGoods.goods.goodsPic}" style="width: 100%;cursor:pointer;"/>
                        </i-col>
                        <i-col span="15" offset="1" style="text-align: left;">
                            <Row style="padding: 5px 15px;margin-top: 12px;">
                                <h1>${secKillGoods.goods.goodsName}</h1>
                            </Row>
                            <Row style="background-color: #eeeeee;padding: 10px 15px;">
                                <span style="color: red;font-size: 22px;font-weight: bold;">
                                    ￥${secKillGoods.seckillPrice}
                                </span>
                                <span style="color: grey;font-size: 15px;text-decoration: line-through;">
                                    ￥${secKillGoods.goods.goodsPrice}
                                </span>
                                <p style="font-size: 16px;">${secKillGoods.goods.goodsDescription}</p>
                                <p style="font-size: 16px;">商品余量 ：${secKillGoods.restNum}</p>
                            </Row>

                            <hr style="margin-top: 20px;border-bottom: dotted; border-bottom-color: #b2b2b2;border-bottom-width: thin;"/>
                            <Row style="text-align: center;font-size: 16px;line-height: 22px;margin-top: 10px;">
                                <i-col span="7">
                                    <label>月销量 </label><span style="color: red;font-weight: bolder;"> 123</span>
                                </i-col>

                                <i-col span="1" style="color: #b2b2b2">|</i-col>

                                <i-col span="7">
                                    <label>累计销量 </label><span style="color: red;font-weight: bolder;"> 1234</span>
                                </i-col>

                                <i-col span="1" style="color: #b2b2b2;">|</i-col>

                                <i-col span="7">
                                    <label>累计评价 </label><span style="color: red;font-weight: bolder;"> 125</span>
                                </i-col>
                            </Row>
                            <hr style="margin-top: 10px;border-bottom: dotted; border-bottom-color: #b2b2b2;border-bottom-width: thin;"/>

                            <Row style="margin-top: 40px;">
                                <i-col span="5" offset="1">
                                    <i-button type="error" style="height: 45px;width: 100%;" @click="purchaseNow">立即抢购</i-button>
                                </i-col>
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
    //# sourceURL=goodsDetail.js
    var app = new Vue({
        el: "#app",

        data: {
            avatarSrc:"/upload/image/defaultAvatar.jpg",
            username:"",
            userId:"",
            haveLogin:false,
            isSeller:false,
            commentCount:0,
            isCollected:false,

            keys:"",

            cartNum:cookie("cartGoodsNum")||0,
            messageNum:cookie("messageNum")||0,
            cartList:[],

            // 分页对象
            page : {
                no: 1,
                total: 2
            },

            purchaseNum:1,
            isSecKill:false,
            commentList:[],
            commentAddList:[],
            commentSellerList:[]
        }
    });

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

    function addCollection(){
        event.stopPropagation();

        console.log("点击了收藏按钮");

        if(app.haveLogin){
            ajaxGet("/onlineSale/addCollection?goodsId="+"${goods.id}"+"&userId="+app.userId,function(res){
                if(res.code==="success"){

                    app.isCollected=true;
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

    function reduceCollection(){
        console.log("点击了取消收藏按钮");
        ajaxGet("/onlineSale/reduceCollection?goodsId="+"${goods.id}"+"&userId="+app.userId,function (res) {
            if(res.code=="success"){
                app.isCollected=false;
            }
        },null,false);
    }

    //计算追评的天数
    function countDay(firstDay,newDay){
        var first=new Date(firstDay);
        var second=new Date(newDay);
        var days=parseInt(Math.abs(first.getTime()-second.getTime())/86400000);
        return days;
    }
    function refreshComments(){

        ajaxGet("/onlineSale/getComments?goodsId="+"${goods.id}"+"&pageNo="+app.page.no+"&keys="+encodeURIComponent(app.keys),function(res){

            app.commentList=res.data.list;
            app.page.total=res.data.total;
            app.commentCount=res.data.total;
        },null,false);



    }


    //切换评论页面
    function changePage(pageNo) {
        if(pageNo != null)
            app.page.no = pageNo;
        refreshComments();
    };

//        ajaxGet("/onlineSale/consumer/getGoods?pageNo="+app.page.no+"&pageSize="+app.page.size+"&keys=" +encodeURIComponent(app.keys)
//            ,function (res) {
//                app.goodsList=res.data.list;
//                app.page.total = res.data.total;
//            },null,false);



    $(document).ready(function () {

        refreshComments();
        if('${isSecKill}'=='true')
        {
            app.isSecKill=true;
        }
        else
        {
            app.isSecKill=false;
        }
        ajaxGet("/onlineSale/getLoginUserInfo",function (res) {
            if(res.code==="success")
            {
                app.username=res.data.userName;
                app.userId=res.data.id;
                app.avatarSrc=res.data.userPic;
                app.haveLogin=true;
                ajaxGet("/onlineSale/requireGoodsCollection?goodsId="+"${goods.id}"+"&userId="+app.userId,function (res) {
                    if(res.code=="success"){
                        app.isCollected=true;
                    }else{
                        app.isCollected=false;
                    }
                },null,false);


                ajaxGet("/onlineSale/getMessageNum?userId="+app.userId,function(res){
                    app.messageNum=res.data;
                    var option={
                        path:"/onlineSale",
                        expires:7
                    };

                    cookie("messageNum",app.messageNum,option);
                },null,false);

                if(res.data.userType==="ADMINISTRATOR")
                {
                    app.isSeller=true;
                }
            }
        },null,false);


    });


    function addToCart()
    {
        //更新cookie值
        var option={
            path:"/onlineSale",
            expires:7,
        };
        var count=app.cartNum;
        cookie("cartGoodsNum",Number(count)+1,option);
        app.cartNum=Number(count)+1;
        var itemNumList=cookie("itemNumList")||"";
        var cartGoodsIdList=cookie("cartGoodsIdList")||"";
        if(cartGoodsIdList=="")
        {
            cartGoodsIdList="${goods.id}";
            itemNumList=app.purchaseNum+"";
        }
        else
        {
            var index=-1;
            var idList=cartGoodsIdList.split(";");
            for(var i=0;i<idList.length;i++)
            {
                if(idList[i]=="${goods.id}")
                {
                    index=i;
                    break;
                }
            }
            if(index==-1)
            {

                var last=cartGoodsIdList.charAt(cartGoodsIdList.length-1);
                if(last==";"){
                    cartGoodsIdList=cartGoodsIdList+"${goods.id}";
                }else{
                    cartGoodsIdList=cartGoodsIdList+";"+"${goods.id}";
                }
                last=itemNumList.charAt(itemNumList.length-1);
                if(last==";"){
                    itemNumList=itemNumList+app.purchaseNum;
                }else{
                    itemNumList=itemNumList+";"+app.purchaseNum;
                }

            }
            else
            {
                var itemNum=itemNumList.split(";");
                itemNum[index]=Number(itemNum[index])+app.purchaseNum;
                itemNumList="";
                for(var i=0;i<itemNum.length-1;i++)
                {
                    itemNumList=itemNumList+itemNum[i]+";";
                }
                itemNumList=itemNumList+itemNum[itemNum.length-1];
            }
        }
        cookie("cartGoodsIdList",cartGoodsIdList,option);
        cookie("itemNumList",itemNumList,option);

    }


    function purchaseNow()
    {
        //alert(returnCitySN["cip"]);//222.130.135.84

        if(app.haveLogin)
        {
            app.$Spin.show({
                    render: function(h)
                    {
                        return h('div', [
                            h('Icon', {
                                'class': 'demo-spin-icon-load',
                                props: {
                                    type: 'load-c',
                                    size: 25
                                }
                            }),
                            h('div', '请勿刷新或关闭窗口。。。')
                        ]);
                }
            });

            var data={goodsId:'${secKillGoods.goods.id}'};
            initWebSocket();
            ajaxPost("/onlineSale/secKill/doSecKill",data,function (res) {

            },null,false);


        }
        else//通过后端跳转到登录页面，因为登录后还得返回当前页
        {
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


    function initWebSocket()
    {
        var webSocket;
        if(app.userId==null||app.userId.length==0)
        {
            app.$Message.warning("用户ID为空");
            return ;
        }
        var host = window.location.host;    //主机IP:port
        if(window.WebSocket)
        {
            webSocket = new WebSocket('ws://'+host+'/webSocket/'+app.userId);
        }
        else
        {
            alert('当前浏览器不支持webSocket');
            return;
        }

        webSocket.onerror = function(event) {
            console.log("socket连接出错");
        };

        webSocket.onopen = function(event) {
            console.log("socket开启连接");
        };

        webSocket.onclose = function(event) {
            console.log("socket关闭连接");
        };

        webSocket.onmessage = function(event)
        {
            app.$Spin.hide();
            if(event.data.substr(0,2)=="恭喜")
            {
                app.$Message.success(event.data);
                app.$Modal.confirm({
                    content: "<h4>抢购商品成功，立即前往查看！</h4>",
                    loading: true,
                    closable:true,
                    onOk: function () {
                        app.$Modal.remove();
                        setTimeout(function () {
                            window.location.href="/onlineSale/myOrder/";
                        },500);
                    },
//                    onCancel:function () {
//                        app.$Modal.remove();
//                        setTimeout(function () {
//                            window.location.href="/onlineSale/myOrder/";
//                        },500);
//                    }
                });
            }
            else
            {
                app.$Message.error(event.data);
                app.$Modal.confirm({
                    content: "<h4>商品秒杀失败，请再接再厉！</h4>",
                    loading: true,
                    closable:true,
                    onOk: function () {
                        app.$Modal.remove();
                    },
                });
            }
        };




        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
        window.onbeforeunload = function ()
        {
            if(webSocket)
            {
                webSocket.close();
            }
        }
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
