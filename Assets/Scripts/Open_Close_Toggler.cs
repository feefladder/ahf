using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Open_Close_Toggler : MonoBehaviour
{
    public GameObject panel;
   
   public void TogglePanelVisibility()
   {
       if (panel !=null) 
       {
           panel.SetActive(!panel.activeSelf);
       }
       
   }
}
