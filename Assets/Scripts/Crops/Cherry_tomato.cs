using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cherry_tomato : Crops
{public Cherry_tomato()
    {

        unitprice = 30;
        crop_name = "Cherry Tomatoes";

        common_pests = "pest";
        base_yield = 180;
        seed_cost = 80;
        required_labor = 11;
    }
}
