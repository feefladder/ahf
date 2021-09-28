using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Livestock : MonoBehaviour
{
    public string type;
    public int cost;
    public int maintenance_cost;
    public double manure_output;
    public int required_labor;
    public int max;
    public Text price_text;


    void Update()
    {
        price_text.text = cost.ToString();
    }


}
