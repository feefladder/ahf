using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Irish : Crops
{
    public Irish() {
       unitprice = 100;
       crop_name = "Irish Potatoes";

        common_pests = "pest";
        base_yield = 100;
        seed_cost = 20;
        required_labor = 10;
}
}
