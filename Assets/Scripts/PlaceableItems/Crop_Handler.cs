using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Crop_Handler : MonoBehaviour
{
    
    public Decision_Handler Handler;
    public Image[] crop_placeholders;
    public Sprite blank;
    public List<Crops> uicrops;
    
    public List<Crops> crops = new List<Crops>(10);
    public GameObject infopanel;
    public Text[] infotext;
    void Start()
    {
        foreach (Crops c in uicrops)
        {
            c.ToggleHandler();
        }
    }

     public void DisplayInfo( Crops c)
    {
        infotext[0].text=c.name;
        infotext[1].text=c.common_pests;
        infotext[2].text=c.diseases;
        infotext[3].text=c.best_time_to_plant;
        infopanel.SetActive(true);        

    }


    public void PurchaseCrops(Crops type)
    {
        if (crops.Count <= 9)
        {

            if (!Handler.DecreaseAssets(type.seed_cost, type.required_labor))
            {
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
    }

    public void SellCrops(Crops type)
    {
        if (!crops.Contains(type))
        {
            return;
        }
        Handler.IncreaseAssets(type.seed_cost, type.required_labor);

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

    public void NewYear()
    {
        foreach (Crops c in uicrops)
        {
            c.loss = 0;
            c.totalexpense = 0;
            c.totalincome = 0;
            c.num = 0;
        }
        for (int i = 0; i < crops.Capacity; i++)
        {
            crop_placeholders[i].sprite = blank;

        }
    }
}
