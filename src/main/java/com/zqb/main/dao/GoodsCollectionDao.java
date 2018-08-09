package com.zqb.main.dao;

import com.zqb.main.entity.GoodsCollection;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GoodsCollectionDao {
    int addGoodsCollection(GoodsCollection goodsCollection);
    int deleteGoodsCollection(GoodsCollection goodsCollection);
    GoodsCollection requireByUserIdAndGoodsId(@Param("userId") String userId,@Param("goodsId") String goodsId);
    List<GoodsCollection> getCollectionGoodsByUserId(String userId);
    int getFocusGoodsNumByUserId(String userId);

}
