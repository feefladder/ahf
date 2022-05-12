using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Goat : Livestock
{
    public Goat()
    {
        type = "Goat";
        cost = 1000;
        maintenance_cost = 400;
        manure_output = 0.25;
        required_labor = 5;
        max = 8;

    }
    public string product = "Milk";
    public int product_revenue = 1000;
}
