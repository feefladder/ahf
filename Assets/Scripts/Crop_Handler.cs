using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Crop_Handler : MonoBehaviour
{
    public double money,labor;
    public Decision_Handler Handler;
    public Image[] crop_placeholders;
    public Sprite blank;
    public List<Crops> uicrops;
    public Text[] cropprices;
    public List<Crops> crops = new List<Crops>(10);
    void Start()
    {
        foreach (Crops c in uicrops)
        {
            c.ToggleHandler();
        }
    }

    void Update()
    {
        money = Handler.money;
        labor = Handler.labor;
        for (int i = 0; i < cropprices.Length; i++)
        {
            cropprices[i].text = uicrops[i].seed_cost.ToString();

        }
    }

    public void PurchaseCrops(Crops type)
    {
        if (crops.Count <= 9)
        {

            if (money >= type.seed_cost)
            {
                money -= type.seed_cost;


            }
            else
            {
                Handler.Nomoney.SetActive(true);
                return;
            }
            if (labor >= type.required_labor)
            {
                labor -= type.required_labor;
            }
            else
            {
                Handler.Nolabour.SetActive(true);
                return;
            }
            crops.Add(type);
            foreach (Crops c in uicrops)
            {
                c.num = 0;
                for (int i = 0; i < crops.Count; i++)
                {
                    if (crops[i] == c)
                    {
                        c.num++;
                    }

                }

            }
            for (int i = 0; i < crops.Count; i++)
            {

                if (crops[i] != null)
                {
                    crop_placeholders[i].sprite = crops[i].sprite;
                }
                else
                {
                    crop_placeholders[i].sprite = blank;
                }
            }

        }
    }

    public void SellCrops(Crops type)
    {
        if (!crops.Contains(type))
        {
            return;
        }
        money += type.seed_cost;
        //total_expenses -= type.seed_cost;
        labor += type.required_labor;

        //crop_placeholders[crops.LastIndexOf(type)].sprite=blank;
        crops.Remove(type);
        foreach (Crops c in uicrops)
        {
            c.num = 0;
            for (int i = 0; i < crops.Count; i++)
            {
                if (crops[i] == c)
                {
                    c.num++;
                }

            }
            // c.displaynumber.text = c.num.ToString();
            //c.area = (c.num / 10) * 100;
        }
        for (int i = 0; i < crops.Capacity; i++)
        {
            crop_placeholders[i].sprite = blank;

        }
        for (int i = 0; i < crops.Count; i++)
        {

            if (crops[i] != null)
            {
                crop_placeholders[i].sprite = crops[i].sprite;
            }
            else
            {
                crop_placeholders[i].sprite = blank;
            }
        }
    }
}
