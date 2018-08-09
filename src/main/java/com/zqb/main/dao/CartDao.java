package com.zqb.main.dao;

import com.zqb.main.entity.Cart;
import com.zqb.main.entity.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by zqb on 2018/4/24.
 */
@Repository
public interface CartDao {

    int add(Cart cart);

    Cart getCartById(@Param("id") String id);

   List<Cart> getCartGoodsByUserId(String userId);

    int getCartNumByUserId(String userId);

    int updateGoodsNumById(@Param("goodsCount") int goodsCount,@Param("id") String id);

    int deleteCartGoodsById(String id);

    Cart getCartByGoodsId(@Param("goodsId") String goodsId,@Param("userId") String userId);

    int deleteCartGoodsByUserId(@Param("userId") String userId);
}
