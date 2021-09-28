using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Crops : MonoBehaviour
{   
    public int unitprice = 100;
    public string crop_name = "defcrop";
    public string common_pests = "pest";
    public int base_yield = 100;
    public int seed_cost = 20;
    public Sprite sprite;
    public int required_labor;
    public Text income_dets;
    public Text expense_dets;
    public Text displaynumber;
    public int area;
    public int num;
    public int totalincome;
    public int totalexpense;
    public int pest_price;
    public Toggle pesticide;
    public int loss;
    public int profit;

}
