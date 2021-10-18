using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoList : MonoBehaviour
{
    public List<Crops> Crops;
    public GameObject prefabItem;
    public RectTransform listRoot;
    public string type;
    public Decision_Handler Decision_Handler;

    void Start()
    {
       // 
    }

    public  void Populate()
    {  Crops = Decision_Handler.uicrops;
        //m_RefreshCallback = null;
        foreach (Transform t in listRoot)
        {
            Destroy(t.gameObject);
        }

        for (int i = 0; i < Crops.Count; ++i)
        {

                GameObject newEntry = Instantiate(prefabItem);
                newEntry.transform.SetParent(listRoot, false);

                ListItem itm = newEntry.GetComponent<ListItem>();

            itm.title.text = Crops[i].crop_name;
            itm.sellprice.text = Crops[i].unitprice.ToString();
            itm.area.text = Crops[i].area.ToString();
            // fertility=pesticide
            itm.fertility.text = Decision_Handler.fertility.ToString();
            itm.total.text = Crops[i].totalincome.ToString();
            if (type=="expense")
            {
                itm.sellprice.text = Crops[i].seed_cost.ToString();
                print(Crops[i].totalexpense);
                itm.total.text = Crops[i].totalexpense.ToString();
                if (Crops[i].pesticide.isOn)
                {
                    itm.fertility.text = Crops[i].pest_price.ToString();
                }
                else itm.fertility.text = "0";
            }
            
            if (itm.loss != null)
            {
                itm.loss.text = Crops[i].loss.ToString();
            }
            

               
           // }
        }
    }

            }
