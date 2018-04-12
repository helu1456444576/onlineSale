package com.zqb.main.entity;

import com.zqb.main.utils.IdGen;

/**
 * Created by zqb on 2018/4/10.
 */
public class BasicEntity {
    private String id;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void preInsert()
    {
        this.id= IdGen.uuid();
    }
}