using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chicken : Livestock
{
    public Chicken()
    {
        type = "Chicken";
        cost = 500;
        maintenance_cost = 100;
        manure_output = 0.05;
        required_labor = 2;
        max = 15;
    }
    public string product = "Eggs";
    public int product_revenue = 600;
}
