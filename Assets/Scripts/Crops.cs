using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Crops : MonoBehaviour
{   
    public double unitprice = 100;
    public string crop_name = "defcrop";
    public string common_pests = "pest";
    public double base_yield = 100;
    public double seed_cost = 20;
    public Text seed_cost_text;
    public Sprite sprite;
    public int required_labor;
    public Text income_dets;
    public Text expense_dets;
    public Text displaynumber;
    public double area;
    public double num;
    public double totalincome;
    public double totalexpense;
    public int pest_price=100;
    public Toggle pesticide;
    public Text pesticide_cost_label;
    public double loss;
    public double profit;

    public void Start()
    {
      //  ToggleHandler();
        
        
    }
    void Update()
    {
        area = (num * 100)/10;
        totalexpense = num * seed_cost;
        if (displaynumber!=null)
        {
            displaynumber.text = num.ToString();
        }
        if (seed_cost_text!=null)
        {
            seed_cost_text.text = seed_cost.ToString();
        }
        
    }
    public void ToggleHandler()
    {
        if (pesticide!=null)
        {
            
            pesticide.GetComponent<Toggle_Handler>().money = pest_price;
            pesticide_cost_label.text = pest_price.ToString();
        }
    }

}
