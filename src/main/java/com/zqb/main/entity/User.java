package com.zqb.main.entity;

/**
 * Created by zqb on 2018/4/3.
 */
public class User extends BasicEntity<User>{

    public int getMoney() {
        return money;
    }

    public void setMoney(int money) {
        this.money = money;
    }

    private int money;
    private String userName;

    private String userPassword;

    private UserType userType;

    private String userPic;

    private String userMobile;

    private String userMail;

    public String getUserMail() {
        return userMail;
    }

    public void setUserMail(String userMail) {
        this.userMail = userMail;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword)
    {
        this.userPassword = userPassword;
    }

    public UserType getUserType() {
        return userType;
    }

    public void setUserType(UserType userType) {
        this.userType = userType;
    }

    public String getUserPic() {
        return userPic;
    }

    public void setUserPic(String userPic) {
        this.userPic = userPic;
    }

    public String getUserMobile() {
        return userMobile;
    }

    public void setUserMobile(String userMobile) {
        this.userMobile = userMobile;
    }

    @Override
    public String toString() {
        return "{" +
                "'id':'" + getId() + '\'' +
                ", 'userName':'" + userName + '\'' +
                ", 'userPassword':'" + userPassword + '\'' +
                ", 'userType':" + userType +
                ", 'userPic':'" + userPic + '\'' +
                ", 'userMobile':'" + userMobile + '\'' +
                ", 'deleteFlag':" + getDeleteFlag() +
                '}';
    }
}
