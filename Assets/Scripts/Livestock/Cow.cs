using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cow : Livestock
{
    public Cow()
    {
        type = "Cow";
        cost = 4500;
        maintenance_cost = 800;
        manure_output = 1;
        max = 4;
        required_labor = 10;
    }
    public string product = "Milk";
    public int product_revenue = 2600;
}
