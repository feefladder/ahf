using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bell : Crops
{
    public Bell()
    {
        unitprice = 10;
        crop_name = "Bell Peppers";

        common_pests = "pest";
        base_yield = 80;
        seed_cost = 40;
        required_labor = 10;
        pest_price = 100;
    }
}
