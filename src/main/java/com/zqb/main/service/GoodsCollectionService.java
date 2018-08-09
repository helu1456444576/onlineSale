package com.zqb.main.service;

import com.zqb.main.dao.GoodsCollectionDao;
import com.zqb.main.entity.GoodsCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class GoodsCollectionService {
    @Autowired
    private GoodsCollectionDao goodsCollectionDao;

    public int addGoodsCollection(GoodsCollection goodsCollection){
        return goodsCollectionDao.addGoodsCollection(goodsCollection);
    }
    public int deleteGoodsCollection(GoodsCollection goodsCollection){
        return goodsCollectionDao.deleteGoodsCollection(goodsCollection);
    }
    public GoodsCollection requireByUserIdAndGoodsId(String userId,String goodsId){
        return goodsCollectionDao.requireByUserIdAndGoodsId(userId,goodsId);
    }

    public List<GoodsCollection> getCollectionGoodsByUserId(String userId){
        return goodsCollectionDao.getCollectionGoodsByUserId(userId);
    }
    public int getFocusGoodsNumByUserId(String userId){
        return goodsCollectionDao.getFocusGoodsNumByUserId(userId);
    }

}
