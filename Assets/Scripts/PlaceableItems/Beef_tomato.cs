using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Beef_tomato : Crops
{
    public Beef_tomato()
    {

        unitprice = 200;
        crop_name = "Beef Tomatoes";

        common_pests = "pest";
        base_yield = 200;
        seed_cost = 100;
        required_labor = 12;
    }
}
